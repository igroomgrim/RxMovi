//
//  MovieListViewController.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import RxDataSources

class MovieListViewController: TableViewController {
    
    @IBOutlet weak var movieListRefreshControl: UIRefreshControl!
    
    var disposeBag = DisposeBag()
    let startPage = 1
    let moviesList = Variable<[Movie]>([])
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMovie>()
    
    override func viewDidLoad() {
        
        dataSource.configureCell = { (_, tableView, indexPath, movie) in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            cell.bind(movie)
            return cell
        }
        
        getMovies(page: startPage)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        let movieSelectedStream = tableView.rx.modelSelected(Movie.self)
        let cellSelectedStream = tableView.rx.itemSelected
        
        Observable.zip(movieSelectedStream, cellSelectedStream) { (movie, indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        .subscribe()
        .addDisposableTo(disposeBag)
        
        movieListRefreshControl.rx.controlEvent(.valueChanged)
            .flatMapLatest ({ [unowned self] _ in
                return self.getMovies(page: self.startPage)
            })
            .map { $0[0].items }
            .bind(to: moviesList)
            .addDisposableTo(disposeBag)
    
        moviesList.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.movieListRefreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)
        
    }
    
    private func getMovies(page: Int) -> Observable<[SectionOfMovie]> {
        return Observable.just(APIService.getMovies(page: page))
            .flatMap({ (service: APIService) -> Observable<Any> in
                return APIProvider.request(service).mapJSON()
            })
            .map { (responseJSON) -> [SectionOfMovie] in
                
                let moviesReponse = Mapper<MoviesReponse>().map(JSONObject: responseJSON)
                guard let movies = moviesReponse?.movies else {
                    return [SectionOfMovie(items: [])]
                }
                
                return [SectionOfMovie(items: movies)]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieDetail", let movieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell = sender as? MovieCell, let indexPath = tableView.indexPath(for: cell) {
            let movie = dataSource[indexPath]
            movieDetailViewController.movieID.value = movie.id
        }
    }
}

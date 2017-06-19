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

class MovieListViewController: TableViewController {
    
    @IBOutlet weak var movieListRefreshControl: UIRefreshControl!
    
    var disposeBag = DisposeBag()
    let startPage = 1
    let moviesList = Variable<[Movie]>([])
    
    override func viewDidLoad() {
    
        getMovies(page: startPage)
        .bind(to: moviesList)
        .addDisposableTo(disposeBag)
 
        moviesList.asObservable()
        .bind(to: tableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { (row: Int, movie: Movie, cell: MovieCell) in
            cell.bind(movie)
        }
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
            .map({ movies -> [Movie] in
                return movies
            })
            .bind(to: moviesList)
            .addDisposableTo(disposeBag)
    
        moviesList.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.movieListRefreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)
    
    }
    
    private func getMovies(page: Int) -> Observable<[Movie]> {
        return Observable.just(APIService.getMovies(page: page))
            .flatMap({ (service: APIService) -> Observable<Any> in
                return APIProvider.request(service).mapJSON()
            })
            .map { (responseJSON) -> [Movie] in
                
                let moviesReponse = Mapper<MoviesReponse>().map(JSONObject: responseJSON)
                guard let movies = moviesReponse?.movies else {
                    return []
                }
                
                return movies
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieDetail", let movieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell = sender as? MovieCell, let indexPath = tableView.indexPath(for: cell) {
            let movie = moviesList.value[indexPath.row]
            movieDetailViewController.movieID.value = movie.id
        }
    }
}

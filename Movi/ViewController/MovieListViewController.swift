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
import RxDataSources

class MovieListViewController: TableViewController {
    
    @IBOutlet weak var movieListRefreshControl: UIRefreshControl!
    
    var disposeBag = DisposeBag()
    let startPage = 1
    let moviesList = Variable<[SectionOfMovie]>([])
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfMovie>()
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        
        setupDataSource()
        setupTableViewAction()
        
        // Bind data to tableView
        moviesList.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        let scrollToBottom = tableView.rx.willDisplayCell
            .flatMap { (_, indexPath) in
                (indexPath.section == self.dataSource.sectionModels.count - 1) && (indexPath.row == (self.dataSource.sectionModels.last?.items.count ?? 0) - 1) ? Observable.just() : Observable.empty()
            }
        
        apiManager.discoverMovies(page: startPage, loadTrigger: scrollToBottom)
            .map { (result) -> [SectionOfMovie] in
                return [SectionOfMovie(items: result.loadedItems)]
            }
            .bind(to: moviesList)
            .addDisposableTo(disposeBag)
        
        // Pull to refresh handler
        movieListRefreshControl.rx.controlEvent(.valueChanged)
            .flatMapLatest ({ [unowned self] _ in
                return self.apiManager.discoverMovies(page: 1, loadTrigger: Observable.empty())
            })
            .map { (result) -> [SectionOfMovie] in
                return [SectionOfMovie(items: result.loadedItems)]
            }
            .bind(to: moviesList)
            .addDisposableTo(disposeBag)
        
        moviesList.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.movieListRefreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)
    }
}

extension MovieListViewController {
    fileprivate func setupDataSource() {
        dataSource.configureCell = { (_, tableView, indexPath, movie) in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            cell.bind(movie)
            return cell
        }
    }
    
    fileprivate func setupTableViewAction() {
        let movieSelectedStream = tableView.rx.modelSelected(Movie.self)
        let cellSelectedStream = tableView.rx.itemSelected
        
        Observable.zip(movieSelectedStream, cellSelectedStream) { (movie, indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}

extension MovieListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieDetail", let movieDetailViewController = segue.destination as? MovieDetailViewController,
            let cell = sender as? MovieCell, let indexPath = tableView.indexPath(for: cell) {
            let movie = dataSource[indexPath]
            movieDetailViewController.movieID.value = movie.id
        }
    }
}

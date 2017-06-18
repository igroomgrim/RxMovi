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
    
    var disposeBag = DisposeBag()
    var currentPage = 1
    
    override func viewDidLoad() {
        
        let requestStream = Observable.just(APIService.getMovies(page: currentPage))
        
        let responseStream = requestStream.flatMap { (service: APIService) -> Observable<Any> in
            return APIProvider.request(service).mapJSON()
        }
        
        responseStream
        .map { (responseJSON) -> [Movie] in
            let moviesReponse = Mapper<MoviesReponse>().map(JSONObject: responseJSON)
            
            guard let movies = moviesReponse?.movies else {
                return []
            }
            
            return movies
        }
        .bind(to: self.tableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { (row: Int, movie: Movie, cell: MovieCell) in
            cell.titleLabel.text = movie.title
        }
        .addDisposableTo(disposeBag)
    }
}

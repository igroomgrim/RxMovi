//
//  APIProvider.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import ObjectMapper

struct APIManager {
    let provider: RxMoyaProvider<APIService>
    
    init() {
        provider = RxMoyaProvider<APIService>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    }
}

extension APIManager {
    func discoverMovies(page: Int, loadTrigger: Observable<Void>) -> Observable<APIResultListState<Movie>> {
        return fetchMoviesRecursively(lastResult: APIService.emptyListResult, loadTrigger: loadTrigger)
    }
    
    func getMovieDetail(id: Int) -> Observable<MovieDetail?> {
        return Observable.just(APIService.getMovie(id: id))
            .flatMap { (service: APIService) -> Observable<Any> in
                return self.provider.request(service).mapJSON()
            }
            .map { (responseJSON) -> MovieDetail? in
                guard let movieDetail = Mapper<MovieDetail>().map(JSONObject: responseJSON) else {
                    return nil
                }
                
                return movieDetail
            }
    }
    
    private func fetchMovies(page: Int = 1) -> Observable<APIResultListState<Movie>> {
        return Observable.just(APIService.getMovies(page: page))
            .flatMap({ (service: APIService) -> Observable<Any> in
                return self.provider.request(service).mapJSON()
            })
            .map({ responseJSON in
                let moviesReponse = Mapper<MoviesReponse>().map(JSONObject: responseJSON)
                guard let movies = moviesReponse?.movies else {
                    return APIResultListState(loadedItems: [], currentPage: page)
                }
                
                return APIResultListState(loadedItems: movies, currentPage: page)
            })
    }
    
    private func fetchMoviesRecursively(lastResult: APIResultListState<Movie>, loadTrigger: Observable<Void>) -> Observable<APIResultListState<Movie>> {
        return fetchMovies(page: lastResult.currentPage).flatMap { result -> Observable<APIResultListState<Movie>> in
            var currentResult = result
            currentResult.loadedItems = lastResult.loadedItems + result.loadedItems
            currentResult.currentPage += 1
            
            return Observable.concat([Observable.just(currentResult),
                                      Observable.never().takeUntil(loadTrigger),
                                      self.fetchMoviesRecursively(lastResult: currentResult, loadTrigger: loadTrigger)])
        }
    }

}

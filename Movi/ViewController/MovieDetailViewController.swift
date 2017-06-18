//
//  MovieDetailViewController.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

class MovieDetailViewController: TableViewController {
    let movieID: Variable<Int?> = Variable(nil)
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieID.asObservable()
            .filter({ $0 != nil })
            .map({ APIService.getMovie(id: $0!) })
            .flatMap { (service: APIService) -> Observable<Any> in
                return APIProvider.request(service).mapJSON()
            }
            .map { (responseJSON) -> MovieDetail? in
                guard let movieDetail = Mapper<MovieDetail>().map(JSONObject: responseJSON) else {
                    return nil
                }
                
                return movieDetail
            }
            .filter({ $0 != nil })
            .map({ $0! })
            .subscribe(onNext: { movie in
                print(movie.synopsis)
            })
            .addDisposableTo(disposebag)
        
    }
}

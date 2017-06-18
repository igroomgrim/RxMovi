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
    
    @IBOutlet weak var backdropCell: BackdropCell!
    @IBOutlet weak var synopsisCell: SynopsisCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

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
            .subscribe(onNext: { [weak self] movie in

                self?.backdropCell.bind(movie)
                self?.synopsisCell.bind(movie)
            })
            .addDisposableTo(disposebag)
        
    }
}

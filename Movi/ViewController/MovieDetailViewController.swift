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

class MovieDetailViewController: TableViewController {
    let movie: Variable<Movie?> = Variable(nil)
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movie.asObservable()
            .filter({ $0 != nil })
            .map({ $0! })
            .subscribe(onNext: { movie in
                print(movie.title)
            })
            .addDisposableTo(disposebag)
    }
}

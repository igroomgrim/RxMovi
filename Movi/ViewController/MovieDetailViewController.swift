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

class MovieDetailViewController: UIViewController {
    let movieID: Variable<Int?> = Variable(nil)
    let disposebag = DisposeBag()
    let apiManager = APIManager()
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieID.asObservable()
            .filter({ $0 != nil })
            .map({ $0! })
            .flatMap({ self.apiManager.getMovieDetail(id: $0) })
            .filter({ $0 != nil })
            .map({ $0! })
            .subscribe(onNext: { [weak self] movie in
                self?.synopsisLabel.text = movie.synopsis ?? "-"
                self?.languageLabel.text = movie.originalLanguage ?? "-"
                
                if let duration = movie.duration {
                    self?.durationLabel.text = (duration != 0) ? "\(duration) min" : "- min"
                }
                
                if let genres = movie.genres {
                    self?.genresLabel.text = genres.reduce("", { (result, genre) -> String in
                        guard let genreName = genre.name else {
                            return "-"
                        }
                        
                        return result + "\(genreName), "
                    })
                }
                
                let imagePath = movie.backdropPath ?? movie.posterPath ?? ""
                let imageUrl = "http://image.tmdb.org/t/p/w500\(imagePath)"
                self?.movieImageView.download(image: imageUrl)
            })
            .addDisposableTo(disposebag)
    }
}

//
//  MovieCell.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    
    func bind(_ movie: Movie) {
        titleLabel.text = movie.title ?? "-"
        
        var popularityPoint: String {
            return String(format: "%.2f", movie.popularity ?? 0)
        }
        
        popularityLabel.text = "Popularity \(popularityPoint)"
        
        guard let posterPath = movie.posterPath else {
            return
        }
        
        let posterUrl = "http://image.tmdb.org/t/p/w500\(posterPath)"
 
        posterImageView.download(image: posterUrl)
 
    }
}

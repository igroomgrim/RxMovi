//
//  BackdropCell.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import UIKit

class BackdropCell: UITableViewCell {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    func bind(_ movie: MovieDetail) {
        let imagePath = movie.backdropPath ?? movie.posterPath ?? ""
        
        let imageUrl = "http://image.tmdb.org/t/p/w500\(imagePath)"
        
        backdropImageView.download(image: imageUrl)
    }
}

//
//  DurationCell.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import UIKit

class DurationCell: UITableViewCell {
    @IBOutlet weak var durationLabel: UILabel!
    
    func bind(_ movie: MovieDetail) {
        durationLabel.text = "Duration : \(movie.duration ?? 0)"
    }
}

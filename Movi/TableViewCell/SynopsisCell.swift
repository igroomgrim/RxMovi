//
//  SynopsisCell.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import UIKit

class SynopsisCell: UITableViewCell {
    @IBOutlet weak var synopsisLabel: UILabel!
    
    func bind(_ movie: MovieDetail) {
        synopsisLabel.text = movie.synopsis ?? ""
    }
}

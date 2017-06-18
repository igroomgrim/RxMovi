//
//  UIImageView+Kingfisher.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
}


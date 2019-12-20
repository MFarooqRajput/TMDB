//
//  UIImageViewExtension.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 19/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with url: URL?, placholder: UIImage = #imageLiteral(resourceName: "placeholder")) {
        self.kf.indicatorType = .activity
        self.kf.setImage (
            with: url,
            placeholder: placholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                debugPrint("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                debugPrint("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

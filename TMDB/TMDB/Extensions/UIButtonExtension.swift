//
//  UIButtonExtension.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation

import UIKit

extension UIButton {
    
    func filterButton(with color: UIColor = .blue) {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 10.0
    }
}

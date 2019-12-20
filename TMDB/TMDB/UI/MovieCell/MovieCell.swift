//
//  MovieCell.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 19/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
    
    public var movie: Movie? {
        didSet {
            guard let movie = movie else {
                return
            }
            
            posterImageView.setImage(with: movie.posterURL)
        }
    }
}

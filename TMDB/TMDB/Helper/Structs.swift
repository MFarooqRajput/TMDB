//
//  Structs.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 19/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation
import XCDYouTubeKit

public struct Constants {
    static let API_KEY = "fce0e28ab0cacfd2f85e32670ad51b11"
    static let BASE_API_URL = "https://api.themoviedb.org/3"
    static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/"
    
    static let endpoints: [Endpoint] = [.nowPlaying, .popular, .upcoming, .topRated]
    
    struct Segues {
        static let detailSegue = "detailSegue"
        static let filterSegue = "filterSegue"
        static let applyUnwindSegue = "applyUnwindSegue"
    }
    
    static let datePickerRows = 75
    static let minYear = 1950
    static let maxYear = 2024
}

public struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

//
//  MovieService.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 19/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation

protocol MovieService {
    
    func fetchMovies(from endpoint: Endpoint, params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func fetchMovie(id: Int, successHandler: @escaping (_ response: Movie) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
}

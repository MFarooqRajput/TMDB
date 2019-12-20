//
//  MovieDetailPresenter.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation
import XCDYouTubeKit

public protocol MovieDetailView: class {
    func updateMovieDetailView()
    func showErrorView(_ error: String)
    func hideErrorView()
    func activityIndicatorAnimatingView(animating: Bool)
    
    func dimissPlayerView()
    func playPlayerView(streamURL: URL)
}

class MovieDetailPresenter {
    
    private weak var view: MovieDetailView?
    
    var movieService: MovieService = MovieStore.shared
    
    var movie: Movie! {
        didSet {
            self.view?.updateMovieDetailView()
        }
    }

    public init(view: MovieDetailView?) {
        self.view = view
    }
    
    func fetchMovieDetail(movieId: Int) {
        
        self.view?.activityIndicatorAnimatingView(animating: true)
        self.view?.hideErrorView()
        
        movieService.fetchMovie(id: movieId, successHandler: {[unowned self] (movie) in
            self.view?.activityIndicatorAnimatingView(animating: false)
            self.movie = movie
        }) { [unowned self] (error) in
            self.view?.activityIndicatorAnimatingView(animating: false)
            self.view?.showErrorView(error.localizedDescription)
        }
        
    }
    
    func videoCount() -> Int {
        return movie?.videos?.results.count ?? 0
    }
    
    func video(index: Int) -> MovieVideo {
        return (movie?.videos?.results ?? [])[index]
    }
    
    func videoXCDYouTubeClient(key: String) {
        XCDYouTubeClient.default().getVideoWithIdentifier(key) {[weak self] (video, error) in
            if let _ = error {
                self?.view?.dimissPlayerView()
                return
            }
            
            guard let video = video else {
                self?.view?.dimissPlayerView()

                return
            }
            
            let streamURL: URL
            if let url = video.streamURLs[YouTubeVideoQuality.hd720]  {
                streamURL = url
            } else if let url = video.streamURLs[YouTubeVideoQuality.medium360] {
                streamURL = url
            } else if let url = video.streamURLs[YouTubeVideoQuality.small240] {
                streamURL = url
            } else if let urlDict = video.streamURLs.first {
                streamURL = urlDict.value
            } else {
                self?.view?.dimissPlayerView()

                return
            }
            
            self?.view?.playPlayerView(streamURL: streamURL)
        }
    }
}


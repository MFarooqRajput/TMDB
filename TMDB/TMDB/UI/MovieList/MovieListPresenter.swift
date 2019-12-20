//
//  MovieListPresenter.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation

public protocol MovieListView: class {
    func reloadView()
    func showErrorView(_ error: String)
    func hideErrorView()
    func activityIndicatorAnimatingView(animating: Bool)
}

class MovieListPresenter {
    
    private weak var view: MovieListView?
    
    var minYear = Constants.minYear
    var maxYear = Constants.maxYear
    var filterParams: [String: String] = [:]
    
    var endpoint: Endpoint?
    var movieService: MovieService = MovieStore.shared
    var movieId: Int!
    
    var page: Int = 1
    var totalPages: Int = 0
    var isPageRefreshing:Bool = false
    
    public init(view: MovieListView?, endPoint: Endpoint) {
        self.view = view
        self.endpoint = endPoint
    }
    
    var movies = [Movie]() {
        didSet {
            self.view?.reloadView()
        }
    }
    
    func getMovieAtIndex(index: Int) -> Movie {
        return movies[index]
    }
    
    func selectMovieAtIndex(index: Int) {
        movieId = movies[index].id
    }
    
    func getTitle() -> String? {
        return endpoint?.description
    }
    
    func shouldFetch() -> Bool {
        return !isPageRefreshing && page < totalPages
    }
    
    func startFetch() {
        isPageRefreshing = true
        page += 1
        fetchMovies()
    }
    
    func endPointChange(endPoint: Endpoint) {
        self.endpoint = endPoint
        loadList()
    }
    
    func setFilterParams(min: Int, max: Int) {
        
        minYear = min
        maxYear = max
        
        filterParams["primary_release_date.gte"] = minYear.description + "-01-01"
        filterParams["primary_release_date.lte"] = maxYear.description + "-12-31"
        
        loadList()
    }
    
    func removewFilterParams() {
        filterParams.removeAll()
        loadList()
    }
    
    func loadList() {
        page = 1
        totalPages = 0
        movies.removeAll()
        fetchMovies()
    }
    
    func fetchMovies() {
        guard let endpoint = endpoint else {
            return
        }
        
        var params: [String: String] = [:]
        params["page"] = String(page)
        
        for filterParams in filterParams {
            params[filterParams.key] = filterParams.value
        }
        
        self.view?.activityIndicatorAnimatingView(animating: true)
        self.view?.hideErrorView()
        
        movieService.fetchMovies(from: endpoint, params: params, successHandler: { [unowned self] (response) in
            self.view?.activityIndicatorAnimatingView(animating: false)
            self.isPageRefreshing = false
            self.totalPages = response.totalPages
            self.movies += response.results
            if self.movies.isEmpty {
                self.view?.showErrorView("No movie found, please refresh OR change release year")
            }
        }) { [unowned self] (error) in
            self.view?.activityIndicatorAnimatingView(animating: false)
            self.isPageRefreshing = false
            self.view?.showErrorView(error.localizedDescription)
        }
    }
}

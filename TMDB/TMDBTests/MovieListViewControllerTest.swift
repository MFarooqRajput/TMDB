//
//  MovieListViewControllerTest.swift
//  TMDBTests
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import XCTest
@testable import TMDB

class MovieListViewControllerTest: XCTestCase {

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func prepareController(presenter: MovieListPresenter? = nil) -> MovieListViewController? {
        let controller = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController
        if let pres = presenter {
            controller?.presenter = pres
        }
        _ = controller?.view
        return controller
    }
    
    
    func testGetMovieAtIndex() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        let movie = ctr.presenter.getMovieAtIndex(index: 0)
        
        // Assert
        XCTAssertEqual(movie.title, "Ad Astra")
        XCTAssertNil(movie.tagline)
        XCTAssertFalse(movie.adult)
    }
    
    func testSelectMovieAtIndex(index: Int) {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.selectMovieAtIndex(index: 0)
        
        // Assert
        XCTAssertEqual(ctr.presenter.movieId, 419704)
    }
    
    func testGetTitle() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        let title = ctr.presenter.getTitle()
        
        // Assert
        XCTAssertEqual(title, "Now Playing")
    }
    
    func testShouldFetch() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.isPageRefreshing = false
        ctr.presenter.page = 1
        ctr.presenter.totalPages = 10
        
        // Assert
        XCTAssertTrue(ctr.presenter.shouldFetch())
    }
    
    func testShouldNotFetch() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.isPageRefreshing = true
        ctr.presenter.page = 1
        ctr.presenter.totalPages = 10
        
        // Assert
        XCTAssertFalse(ctr.presenter.shouldFetch())
    }
    
    func startFetch() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.isPageRefreshing = false
        ctr.presenter.page = 1
        ctr.presenter.totalPages = 10
        ctr.presenter.startFetch()
        
        // Assert
        XCTAssertTrue(ctr.presenter.isPageRefreshing)
        XCTAssertEqual(ctr.presenter.page, 2)
    }
    
    func testEndPointChange() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.endPointChange(endPoint: .popular)
        
        // Assert
        XCTAssertEqual(ctr.presenter.endpoint?.description, "Popular")
    }
    
    func testSetFilterParams() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.setFilterParams(min: 2005, max: 2010)
        
        // Assert
        XCTAssertEqual(ctr.presenter.filterParams["primary_release_date.gte"], "2005-01-01")
        XCTAssertEqual(ctr.presenter.filterParams["primary_release_date.lte"], "2010-12-31")
    }
    
    func testRemovewFilterParams() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.removewFilterParams()
        
        // Assert
        XCTAssert(ctr.presenter.filterParams.keys.count == 0)
    }
    
    func testLoadList() {
        // Arrange
        guard let ctr = prepareController() else { return }
        prefill(ctr: ctr)
        
        // Act
        ctr.presenter.loadList()
        
        // Assert
        XCTAssert(ctr.presenter.movies.count == 0)
        XCTAssertEqual(ctr.presenter.page, 1)
        XCTAssertEqual(ctr.presenter.totalPages, 0)
    }
    
    func prefill(ctr: MovieListViewController) {
        
        let movie1 = Movie(id: 419704, title: "Ad Astra", backdropPath: "/5BwqwxMEjeFtdknRV792Svo0K1v.jpg", posterPath: "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg", overview: "The near future, a time when both hope and hardships drive humanity to look to the stars and beyond. While a mysterious phenomenon menaces to destroy life on planet Earth, astronaut Roy McBride undertakes a mission across the immensity of space and its many perils to uncover the truth about a lost expedition that decades before boldly faced emptiness and silence in search of the unknown.", releaseDate: Date(), voteAverage: 6.1, voteCount: 1340, tagline: nil, genres: nil, videos: nil, credits: nil, adult: false, runtime: nil)
        
        let movie2 = Movie(id: 181812, title: "Star Wars: The Rise of Skywalker", backdropPath: "/jOzrELAzFxtMx2I4uDGHOotdfsS.jpg", posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", overview: "The next installment in the franchise and the conclusion of the “Star Wars“ sequel trilogy as well as the “Skywalker Saga.”", releaseDate: Date(), voteAverage: 6.7, voteCount: 288, tagline: nil, genres: nil, videos: nil, credits: nil, adult: false, runtime: nil)
            
        ctr.presenter.movies.append(movie1)
        ctr.presenter.movies.append(movie2)
    }
}


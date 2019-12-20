//
//  FilterViewControllerTest.swift
//  TMDBTests
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import XCTest
@testable import TMDB

class FilterViewControllerTest: XCTestCase {

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func prepareController(presenter: FilterPresenter? = nil) -> FilterViewController? {
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
        
        let filterPresenter = FilterPresenter()
        controller?.presenter = filterPresenter
        /*if let pres = presenter {
            controller?.presenter = filterPresenters
        }*/
        _ = controller?.view
        return controller
    }
    
    func testSetIsMinYear(bool: Bool) {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.setIsMinYear(bool: true)
        
        // Assert
        XCTAssertTrue(ctr.presenter.isMinYear)
    }
    
    func testTitleForMin() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        
        // Assert
        XCTAssertEqual(ctr.presenter.titleForMin(), "1950")
    }
    
    func testTitleForMinDef() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        
        // Assert
        XCTAssertEqual(ctr.presenter.titleForMin(def: true), "Min Year")
    }
    
    
    func testTitleForMax() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.maxYear = 2000
        
        // Assert
        XCTAssertEqual(ctr.presenter.titleForMax(), "2000")
    }
    
    func testTitleForMaxDef() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.maxYear = 2000
        
        // Assert
        XCTAssertEqual(ctr.presenter.titleForMax(def: true), "Max Year")
    }
    
    func testDatePicketSelectedRowMin() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        ctr.presenter.maxYear = 2000
        ctr.presenter.isMinYear = true
        
        // Assert
        XCTAssertEqual(ctr.presenter.datePicketSelectedRow(), 0)
    }
    
    func testDatePicketSelectedRowMax() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        ctr.presenter.maxYear = 2000
        ctr.presenter.isMinYear = false
        
        // Assert
        XCTAssertEqual(ctr.presenter.datePicketSelectedRow(), 50)
    }
    
    func testSetFilterYearMin(selectedRow: Int) {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        ctr.presenter.maxYear = 2000
        ctr.presenter.isMinYear = true
        ctr.presenter.setFilterYear(selectedRow: 10)
        
        // Assert
        XCTAssertEqual(ctr.presenter.minYear, 1960)
        XCTAssertEqual(ctr.presenter.maxYear, 2000)
    }
    
    func testSetFilterYearMax(selectedRow: Int) {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        ctr.presenter.maxYear = 2000
        ctr.presenter.isMinYear = false
        ctr.presenter.setFilterYear(selectedRow: 10)
        
        // Assert
        XCTAssertEqual(ctr.presenter.minYear, 1950)
        XCTAssertEqual(ctr.presenter.maxYear, 1960)
    }
    
    func testCheckValidFilter() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 1950
        ctr.presenter.maxYear = 2000
        
        // Assert
        XCTAssertTrue(ctr.presenter.checkValidFilter())
    }
    
    func testCheckInValidFilter() {
        // Arrange
        guard let ctr = prepareController() else { return }
        
        // Act
        ctr.presenter.minYear = 2000
        ctr.presenter.maxYear = 1950
        
        // Assert
        XCTAssertFalse(ctr.presenter.checkValidFilter())
    }
}



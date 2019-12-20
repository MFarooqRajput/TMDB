//
//  FilterPresenter.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import Foundation

class FilterPresenter {
    
    var isMinYear = true
    var minYear = Constants.minYear
    var maxYear = Constants.maxYear
    
    func setIsMinYear(bool: Bool) {
        isMinYear = bool
    }
    
    func titleForMin(def: Bool = false) -> String {
        return def ? "Min Year" : minYear.description 
    }
    
    func titleForMax(def: Bool = false) -> String {
        return def ? "Max Year" : maxYear.description
    }
    
    func datePicketSelectedRow() -> Int {
        return isMinYear ? (minYear - Constants.minYear) : (maxYear - Constants.minYear)
    }
    
    func setFilterYear(selectedRow: Int) {
        let selectedYear =  Constants.minYear + selectedRow
        isMinYear ? (minYear = selectedYear) : (maxYear = selectedYear)
    }
    
    func checkValidFilter() -> Bool {
        return minYear <= maxYear
    }
}



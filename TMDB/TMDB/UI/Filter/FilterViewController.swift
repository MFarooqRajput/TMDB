//
//  FilterViewController.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 20/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var minYearButton: UIButton!
    @IBOutlet weak var maxYearButton: UIButton!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet var infoLabel: UILabel!
    
    var presenter: FilterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        cancelButton.filterButton()
        resetButton.filterButton(with: .red)
        applyButton.filterButton()
        minYearButton.filterButton()
        maxYearButton.filterButton()
        yearButtonTitle()
        hidePicker()
    }

    private func yearButtonTitle() {
         minYearButton.setTitle(presenter.titleForMin(), for: .normal)
         maxYearButton.setTitle(presenter.titleForMax(), for: .normal)
    }
    
    private func showPicker() {
        datePicker.selectRow(presenter.datePicketSelectedRow(), inComponent: 0, animated: true)
        datePicker.isHidden = false
    }
    
    private func hidePicker() {
        datePicker.isHidden = true
    }
    
    private func validFilter() {
        performSegue(withIdentifier: Constants.Segues.applyUnwindSegue, sender: self)
    }
    
    private func invalidFilter() {
        infoLabel.text = "Minimum year should be less or equal to max year"
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
        presenter.checkValidFilter() ? validFilter() : invalidFilter()
    }
    
    @IBAction func minYear(_ sender: Any) {
        presenter.setIsMinYear(bool: true)
        
        maxYearButton.setTitle(presenter.titleForMax(), for: .normal)
        minYearButton.setTitle(presenter.titleForMin(def: true), for: .normal)
        
        showPicker()
    }
    
    @IBAction func maxYear(_ sender: Any) {
        presenter.setIsMinYear(bool: false)
        
        minYearButton.setTitle(presenter.titleForMin(), for: .normal)
        maxYearButton.setTitle(presenter.titleForMax(def: true), for: .normal)
        
        showPicker()
    }
    
}

// MARK: - UIPickerView

extension FilterViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.datePickerRows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(Constants.minYear + row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.setFilterYear(selectedRow: pickerView.selectedRow(inComponent: 0))
        yearButtonTitle()
        hidePicker()
    }
}

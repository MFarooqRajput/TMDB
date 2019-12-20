//
//  ViewController.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 18/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var endpointSegmentedControl: UISegmentedControl!
    @IBOutlet var movieListCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    
    var presenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieListPresenter(view: self, endPoint: Constants.endpoints[endpointSegmentedControl.selectedSegmentIndex])
        movieListCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.title = presenter.getTitle()
        presenter.loadList()
    }
    
    private func moveMovieListCollectionViewToTop () {
        movieListCollectionView.setContentOffset(.zero, animated: true)
        self.title = presenter.getTitle()
    }
    
    private func showError(_ error: String) {
        infoLabel.text = error
        infoLabel.isHidden = false
        refreshButton.isHidden = false
    }
    
    private func hideError() {
        infoLabel.isHidden = true
        refreshButton.isHidden = true
    }
    
    private func activityIndicatorAnimating(animating: Bool ) {
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        moveMovieListCollectionViewToTop ()
        presenter.loadList()
    }
    
    @IBAction func endPointChanged(_ sender: Any) {
        presenter.endPointChange(endPoint: Constants.endpoints[endpointSegmentedControl.selectedSegmentIndex])
        moveMovieListCollectionViewToTop ()
    }
    
    @IBAction func filter(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.filterSegue, sender: self)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.detailSegue {
            if let movieDetailViewController = segue.destination as? MovieDetailViewController {
                movieDetailViewController.movieId = presenter.movieId
            }
        }
        
        if segue.identifier == Constants.Segues.filterSegue {
            if let filterViewController = segue.destination as? FilterViewController {
                let filterPresenter = FilterPresenter()
                filterPresenter.minYear = presenter.minYear
                filterPresenter.maxYear = presenter.maxYear
                filterViewController.presenter = filterPresenter
            }
        }
    }
    
    // MARK: - unwindSegue
    
    @IBAction func reset(_ unwindSegue: UIStoryboardSegue) {
        moveMovieListCollectionViewToTop ()
        presenter.removewFilterParams()
    }
    
    @IBAction func apply(_ unwindSegue: UIStoryboardSegue) {
        guard let filterViewController = unwindSegue.source as? FilterViewController, let filterPresent = filterViewController.presenter else {
                return
        }
        moveMovieListCollectionViewToTop ()
        presenter.setFilterParams(min: filterPresent.minYear, max: filterPresent.maxYear)
    }
    
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCell
        cell.movie = presenter.getMovieAtIndex(index: indexPath.item)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectMovieAtIndex(index: indexPath.item)
        performSegue(withIdentifier: Constants.Segues.detailSegue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 16) / 2
        let height = width / 2 + width
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - UIScrollViewDelegate

extension MovieListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(movieListCollectionView.contentOffset.y >= (movieListCollectionView.contentSize.height - movieListCollectionView.bounds.size.height)) {
            if presenter.shouldFetch() {
                presenter.startFetch()
            }
        }
    }
    
}

// MARK: - MovieListView protocol methods

extension MovieListViewController: MovieListView {
    
    func reloadView() {
        movieListCollectionView.reloadData()
    }
    
    func showErrorView(_ error: String) {
        self.showError(error)
    }
    
    func hideErrorView() {
        self.hideError()
    }
    
    func activityIndicatorAnimatingView(animating: Bool) {
        activityIndicatorAnimating(animating: animating)
    }
}

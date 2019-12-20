//
//  DetailViewController.swift
//  TMDB
//
//  Created by Muhammmad Farooq on 18/12/2019.
//  Copyright © 2019 Digitacs. All rights reserved.
//

import UIKit
import Kingfisher

import AVKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var movieDetailTableView: UITableView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
 
    let playerVC = AVPlayerViewController()
    
    var presenter: MovieDetailPresenter!
    var movieId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailTableView.register(MovieDetailCell.nib, forCellReuseIdentifier: "DetailCell")
        presenter = MovieDetailPresenter(view: self)
        presenter.fetchMovieDetail(movieId: movieId)
    }
    
    private func updateMovieDetail() {
        guard let movie = presenter.movie else {
            return
        }
        
        titleLabel.text = movie.title
        backdropImageView.setImage(with: movie.backdropURL, placholder: #imageLiteral(resourceName: "film-placeholder"))
        posterImageView.setImage(with: movie.posterURL)
        
        movieDetailTableView.reloadData()

    }
    
    private func showError(_ error: String) {
        infoLabel.text = error
        infoLabel.isHidden = false
        refreshButton.isHidden = false
    }
    
    private func activityIndicatorAnimating(animating: Bool ) {
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    private func hideError() {
        infoLabel.isHidden = true
        refreshButton.isHidden = true
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        presenter.fetchMovieDetail(movieId: movieId)
    }
}

// MARK: - UITableViewDataSource

extension MovieDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.movie == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : presenter.videoCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! MovieDetailCell
            cell.movie = presenter.movie
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            //let video = (presenter.movie?.videos?.results ?? [])[indexPath.row]
            let video = presenter.video(index: indexPath.row)
            cell.textLabel?.text = video.name
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension MovieDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let video = presenter.video(index: indexPath.row)
            playVideo(key: video.key)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Trailers"
        }
        return nil
    }
    
}

//MARK: - AVPlayer

extension MovieDetailViewController {
    private func playVideo(key: String) {
        //let playerVC = AVPlayerViewController()
        present(playerVC, animated: true, completion: nil)
        presenter.videoXCDYouTubeClient(key: key)
        
    }
    
    private func dimissPlayer() {
        playerVC.dismiss(animated: true, completion: nil)
    }
    
    private func playPlayer(streamURL: URL) {
        playerVC.player = AVPlayer(url: streamURL)
        playerVC.player?.play()
    }
}

// MARK: - MovieDetailView protocol methods

extension MovieDetailViewController: MovieDetailView {
    func updateMovieDetailView() {
        updateMovieDetail()
    }
    
    func showErrorView(_ error: String) {
        showError(error)
    }
    
    func hideErrorView() {
        hideError()
    }
    
    func activityIndicatorAnimatingView(animating: Bool) {
        activityIndicatorAnimating(animating: animating)
    }
    
    func dimissPlayerView() {
        dimissPlayer()
    }
    
    func playPlayerView(streamURL: URL) {
        playPlayer(streamURL: streamURL)
    }
}

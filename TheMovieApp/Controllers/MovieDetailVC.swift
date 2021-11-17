//
//  MovieDetailTVC.swift
//  TheMovieApp
//
//  Created by Josh R on 1/4/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Combine
import UIKit

final class MovieDetailVC: UIViewController {

    private var cancellables: Set<AnyCancellable> = []

    private lazy var viewModel = MovieDetailVCViewModel(movieID: passedMovieID)

    var passedMovieID = "330457"  //default value for SwiftUI preview

    private let bannerImgView = UIImageView()
    private let postImgView = UIImageView()

    private lazy var movieTitleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.text = "Loading..."
        return label
    }()

    private lazy var movieRatingLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.minimumScaleFactor = 0.5
        label.text = "Rating"
        return label
    }()

    private lazy var genreLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = "Genre"
        return label
    }()

    private lazy var releaseDateSV: ReleaseDateSV = {
        let sv = ReleaseDateSV()
        return sv
    }()

    private lazy var summaryLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 10
        label.text = "Loading summary..."
        return label
    }()

    private lazy var closeBtn: CloseBtn = {
        let button = CloseBtn()
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6  //use systemGray6 or systemBackground
        addViewsToVC()
        addViewConstraints()

        subscribeToMovieDetails()
        subscribeToReleaseDates()
    }

    @objc func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func addViewsToVC() {
        bannerImgView.contentMode = .scaleAspectFit
        postImgView.contentMode = .scaleAspectFit

        view.addSubview(bannerImgView)
        view.addSubview(postImgView)
        view.addSubview(movieTitleLbl)
        view.addSubview(movieRatingLbl)
        view.addSubview(genreLbl)
        view.addSubview(releaseDateSV)
        view.addSubview(summaryLbl)
        view.addSubview(closeBtn)
    }

    private func addViewConstraints() {
        bannerImgView.translatesAutoresizingMaskIntoConstraints = false
        postImgView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        movieRatingLbl.translatesAutoresizingMaskIntoConstraints = false
        genreLbl.translatesAutoresizingMaskIntoConstraints = false
        releaseDateSV.translatesAutoresizingMaskIntoConstraints = false
        summaryLbl.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bannerImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bannerImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -12),
            bannerImgView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: 12),
            bannerImgView.heightAnchor.constraint(equalToConstant: 235),

            postImgView.topAnchor.constraint(equalTo: bannerImgView.bottomAnchor, constant: -50),
            postImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),

            postImgView.widthAnchor.constraint(equalToConstant: 125),
            postImgView.heightAnchor.constraint(equalToConstant: 200),

            movieTitleLbl.topAnchor.constraint(equalTo: bannerImgView.bottomAnchor, constant: 2),
            movieTitleLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5),
            movieTitleLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            movieRatingLbl.topAnchor.constraint(equalTo: movieTitleLbl.bottomAnchor, constant: 2),
            movieRatingLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5),

            genreLbl.topAnchor.constraint(equalTo: movieRatingLbl.bottomAnchor, constant: 2),
            genreLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5),
            genreLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            //SV contains all the release date labels
            releaseDateSV.topAnchor.constraint(equalTo: genreLbl.bottomAnchor, constant: 2),
            releaseDateSV.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5),

            summaryLbl.topAnchor.constraint(equalTo: postImgView.bottomAnchor, constant: 20),
            summaryLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            summaryLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),

            closeBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            closeBtn.heightAnchor.constraint(equalToConstant: closeBtn.frame.height),
        ])
    }

    private func subscribeToMovieDetails() {
        viewModel.$movie
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] movie in
                let backdropURL = URL(string: movie.retrieveImgURLString(with: .backdropW1280))
                self?.bannerImgView.kf.setImage(with: backdropURL)

                let posterURL = URL(string: movie.retrieveImgURLString(with: .posterW154))
                self?.postImgView.kf.setImage(with: posterURL)

                self?.movieTitleLbl.text = movie.title
                self?.summaryLbl.text = movie.overview ?? "No Summary Available"
                self?.genreLbl.text = movie.genresString
            }.store(in: &cancellables)
    }

    private func subscribeToReleaseDates() {
        viewModel.$movieReleaseDates
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] movieReleaseDates in
                self?.movieRatingLbl.text = movieReleaseDates.first?.certification ?? "No Rating"
                let theaterReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .theatrical, in: movieReleaseDates)
                self?.releaseDateSV.theaterReleaseDateLbl.text = "Theatrical: \(DateFormatters.convertZTime(zStringDate: theaterReleaseDate))"
                let digitalReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .digital, in: movieReleaseDates)
                self?.releaseDateSV.digitalReleaseDateLbl.text = "Digital: \(DateFormatters.convertZTime(zStringDate: digitalReleaseDate))"
                let physicalReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .physical, in: movieReleaseDates)
                self?.releaseDateSV.physicalReleaseDateLbl.text = "Physical: \(DateFormatters.convertZTime(zStringDate: physicalReleaseDate))"
        }.store(in: &cancellables)
    }
}

// MARK: SwiftUI Preview for UIKit

#if DEBUG
import SwiftUI

struct MovieDetailVC_Preview: PreviewProvider {
    static var previews: some View {
        MovieDetailVC().toPreview().edgesIgnoringSafeArea(.all)
    }
}
#endif

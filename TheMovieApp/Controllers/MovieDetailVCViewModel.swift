//
//  MovieDetailVCViewModel.swift
//  TheMovieApp
//
//  Created by Josh R on 11/15/21.
//  Copyright © 2021 Josh R. All rights reserved.
//

import Combine
import Foundation

final class MovieDetailVCViewModel: ObservableObject {

    @Published var movie: Movie?
    @Published var movieReleaseDates: [ReleaseDate] = []

    private var movieID: String

    private let tmdbManager: TMDbManager

    init(movieID: String, tbmdManager: TMDbManager = TMDbManager()) {
        self.movieID = movieID
        self.tmdbManager = tbmdManager

        getDetailsBy()
        getReleaseDates()
    }

    private func getDetailsBy() {
        tmdbManager.tmdbRequest(Movie.self, endPoint: .getDetails(movieID)) { [weak self] (result) in
            switch result {
            case .success(let movie):
                self?.movie = movie
            case .failure(let error):
                print("Movie detail error: \(error.localizedDescription)")
            }
        }
    }

    private func getReleaseDates() {
        tmdbManager.tmdbRequest(MovieReleaseDateResult.self, endPoint: .getReleaseDates(movieID)) { [weak self] (result) in
            switch result {
            case .success(let movieReleaseDateResult):
                self?.movieReleaseDates = movieReleaseDateResult.unitedStatesReleaseDates ?? []
            case .failure(let error):
                print("Movie release date error: \(error.localizedDescription)")
            }
        }
    }
}

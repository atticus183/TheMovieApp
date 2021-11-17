//
//  MediaCVCViewModel.swift
//  TheMovieApp
//
//  Created by Josh R on 11/15/21.
//  Copyright © 2021 Josh R. All rights reserved.
//

import Combine
import Foundation

final class MediaCVCViewModel: ObservableObject {

    @Published var upcomingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []

    private let tmdbManager: TMDbManager

    init(tbmdManager: TMDbManager = TMDbManager()) {
        self.tmdbManager = tbmdManager

        //Retrieve movies from JSON network call
        downloadUpcomingMovies()
        downloadPopularMovies()
        downloadNowShowingMovies()
    }

    private func downloadUpcomingMovies() {
        tmdbManager.tmdbRequest(UpcomingResults.self, endPoint: .getUpcoming) { [weak self] (result) in
            switch result {
            case .success(let result):
                self?.upcomingMovies = result.results?.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! })  ?? []
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }

    private func downloadPopularMovies() {
        tmdbManager.tmdbRequest(PopularResults.self, endPoint: .getPopular) { [weak self] result in
            switch result {
            case .success(let result):
                self?.popularMovies = result.results.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! })
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }

    private func downloadNowShowingMovies() {
        tmdbManager.tmdbRequest(NowPlayingResults.self, endPoint: .getNowPlaying) { [weak self] result in
            switch result {
            case .success(let result):
                self?.nowPlayingMovies = result.results.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! })
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }
}

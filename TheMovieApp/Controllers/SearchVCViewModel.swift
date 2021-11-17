//
//  SearchVCViewModel.swift
//  TheMovieApp
//
//  Created by Josh R on 11/16/21.
//  Copyright © 2021 Josh R. All rights reserved.
//

import SwiftUI

final class SearchVCViewModel: ObservableObject {

    @Published var searchedMovies: [Movie] = []

    private let tmdbManager: TMDbManager

    init(tbmdManager: TMDbManager = TMDbManager()) {
        self.tmdbManager = tbmdManager
    }

    func searchForMovie(with searchText: String) {
        tmdbManager.searchForMovie(with: searchText) { [weak self] result in
            switch result {
            case .success(let searchResults):
                self?.searchedMovies = searchResults.results?.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 }) ?? []
            case .failure(let error):
                print("Error search for movie: \(error.errorMessage). \(error.localizedDescription)")
            }
        }
    }
}

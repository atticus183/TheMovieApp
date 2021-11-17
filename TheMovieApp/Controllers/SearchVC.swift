//
//  SearchVC.swift
//  TheMovieApp
//
//  Created by Josh R on 1/6/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class SearchVC: UIViewController {

    fileprivate enum Section {
        case main
    }

    private var cancellables: Set<AnyCancellable> = []

    private var dataSource: UITableViewDiffableDataSource<Section, Movie>!

    private var viewModel = SearchVCViewModel()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.barStyle = .default
        sb.placeholder = "Search for movie"
        sb.keyboardType = .default
        sb.searchBarStyle = .minimal
        sb.becomeFirstResponder()
        sb.showsCancelButton = true
        sb.delegate = self
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tv.rowHeight = 100
        tv.tableFooterView = UIView()  //removes empty cells at the bottom
        tv.delegate = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        addViews(views: searchBar, tableView)
        setConstraints()

        viewModel.$searchedMovies
            .receive(on: RunLoop.main)
            .sink { [weak self] movies in
                self?.configureDataSource()
                self?.createSnapshot(from: movies)
            }.store(in: &cancellables)
    }

    //MARK: Darkmode ui adjustments: https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    }

    private func addViews(views: UIView...) {
        views.forEach { self.view.addSubview($0) }
    }

    private func setConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: 0),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
        ])
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView, cellProvider: { (tableView, indexPath, searchMovie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
            cell.movie = searchMovie
            return cell
        })
    }

    private func createSnapshot(from movies: [Movie]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapShot.appendSections([.main])
        snapShot.appendItems(movies, toSection: .main)
        dataSource.apply(snapShot)
        dataSource.defaultRowAnimation = .bottom
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tappedMovie = dataSource?.itemIdentifier(for: indexPath) else { return }

        let movieDetailVC = MovieDetailVC()
        movieDetailVC.passedMovieID = String(tappedMovie.id ?? 1)
        movieDetailVC.modalPresentationStyle = .fullScreen
        present(movieDetailVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchForMovie(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: SwiftUI Preview for UIKit

#if DEBUG
import SwiftUI

struct SearchVC_Preview: PreviewProvider {
    static var previews: some View {
        SearchVC().toPreview().edgesIgnoringSafeArea(.all)
    }
}
#endif



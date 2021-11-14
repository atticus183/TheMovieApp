//
//  SearchVC.swift
//  TheMovieApp
//
//  Created by Josh R on 1/6/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import SwiftUI
import UIKit

final class SearchVC: UIViewController {

    fileprivate enum Section {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, Movie>!

    private var searchedMovies: [Movie] = []

    private lazy var tmdbManager = TMDbManager()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.barStyle = .default
        sb.placeholder = "Enter movie"
        sb.keyboardType = .default
        sb.searchBarStyle = .minimal
        sb.becomeFirstResponder()
        sb.showsCancelButton = true
        sb.delegate = self
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchCell.self, forCellReuseIdentifier: SearchCell.cellID)
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
        configureDataSource()
        createSnapshot(from: searchedMovies)
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
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: 0),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
        ])
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView, cellProvider: { (tableView, indexPath, searchMovie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.cellID, for: indexPath) as! SearchCell
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
        let tappedMovie = dataSource?.itemIdentifier(for: indexPath)
        guard let movie = tappedMovie else { return }

        let movieDetailVC = MovieDetailVC()
        movieDetailVC.passedMovieID = String(movie.id ?? 1)
        movieDetailVC.modalPresentationStyle = .fullScreen
        present(movieDetailVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tmdbManager.searchForMovie(with: searchText) { [weak self] (result) in
            switch result {
            case .success(let searchResults):
                self?.searchedMovies = searchResults.results?.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 }) ?? []
                DispatchQueue.main.async {
                    self?.createSnapshot(from: self?.searchedMovies ?? [])
                }
            case .failure(let error):
                print("Error search for movie: \(error.errorMessage).  \(error.localizedDescription)")
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: SwiftUI setup to allow preview updates with UIKit
//NOTE:  The use of fileprivate is so you don't have to create new struct names each file you use this in
//Steps to copy this to another file:
//import SwiftUI
//change VC the typealias is referring to
//change the name of the PreviewProvider struct below to something unique

fileprivate typealias ThisViewController = SearchVC //update to this file's VC

fileprivate struct IntegratedController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<IntegratedController>) -> ThisViewController {
        return ThisViewController()
    }
    
    func updateUIViewController(_ uiViewController: ThisViewController, context: UIViewControllerRepresentableContext<IntegratedController>) {
    }
}


//This needs to be changed to something unique IF root vc
fileprivate struct SecondContentView: View {
    var body: some View {
        IntegratedController().edgesIgnoringSafeArea(.all)
        //        IntegratedController()
    }
}

//This needs to be changed to something unique, cannot be fileprivate
struct SearchVC_ContentView_Preview: PreviewProvider {
    static var previews: some View {
        SecondContentView()  //if preview isn't changing, change this struct to the struct conforming to View
    }
}



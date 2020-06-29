//
//  SearchVC.swift
//  TheMovieApp
//
//  Created by Josh R on 1/6/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import SwiftUI

class SearchVC: UIViewController {
    
    fileprivate enum Section {
        case main
    }
    
    private var dataSource: UITableViewDiffableDataSource<Section, Movie>!
    
    var searchedMovies: [Movie]?
    
    lazy var tmdbManager = TMDbManager()
    
    let searchBar = UISearchBar()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6  //if using one of the system colors, you don't need to change the color in traitCollectionDidChange
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.cellID)
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()  //removes empty cells at the bottom
        tableView.delegate = self
        
        addViews(views: searchBar, tableView)
        setConstraints()
        setupSearchBar()
        
        configureDataSource()
        createSnapshot(from: searchedMovies)
    }
    
    //Customize searchBar: https://stackoverflow.com/questions/36542549/customize-search-bar
    private func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.placeholder = "Enter movie"
        searchBar.keyboardType = .default
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    

    //MARK: Darkmode ui adjustments: https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("traitCollectionDidChange")
    }
    
    private func addViews(views: UIView...) {
        views.forEach({ self.view.addSubview($0) })
    }
    
    private func setConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: 0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0).isActive = true
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView, cellProvider: { (tableView, indexPath, searchMovie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.cellID, for: indexPath) as! SearchCell
            //NOTE:  There is no need to perform the indexPath.row logic.  The object is retrieved from the searchMovie closure parameter
            cell.movie = searchMovie
            return cell
        })
    }
    
    private func createSnapshot(from movies: [Movie]?) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapShot.appendSections([.main])
        if let searchedMovies = movies {
            snapShot.appendItems(searchedMovies, toSection: .main)
        }

        dataSource.apply(snapShot)
        dataSource.defaultRowAnimation = .bottom
    }
    
 
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedMovie = dataSource?.itemIdentifier(for: indexPath)
        guard let movie = tappedMovie else { return }
        print("\(String(describing: movie.title)), movieID: \(String(describing: movie.id)), date: \(String(describing: movie.releaseDate))")
        
        let movieDetailVC = MovieDetailVC()
        movieDetailVC.passedMovieID = String(movie.id ?? 1)
        movieDetailVC.modalPresentationStyle = .fullScreen
        self.present(movieDetailVC, animated: true, completion: nil)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tmdbManager.searchForMovie(with: searchText) { [weak self] (result) in
            switch result {
            case .success(let searchResults):
                self?.searchedMovies = searchResults.results?.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })
                DispatchQueue.main.async {
                    self?.createSnapshot(from: self?.searchedMovies)
                }
            case .failure(let error):
                print("Error search for movie: \(error.errorMessage).  \(error.localizedDescription)")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
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



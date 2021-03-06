//
//  MediaCVC.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit


class MediaCVC: UICollectionViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<MovieStatus, Movie>?
    
    lazy var tmdbManager = TMDbManager()
    
    let dispatchGroup = DispatchGroup()
    
    var upcomingMovies: [Movie]?
    var popularMovies: [Movie]?
    var nowPlayingMovies: [Movie]?
    
    let movieStatues = MovieStatus.allCases
    
    lazy var searchBtn: SearchButton = {
        let button = SearchButton()
        button.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc func searchBtnTapped() {
        let searchVC = SearchVC()
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = .systemBackground  //if using one of the system colors, you don't need to change the color in traitCollectionDidChange, //use systemGray6 or systemBackground
        setupSearchButton()
        
        //MARK: Setup collectionView
        //CollectionView elements registration
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        self.collectionView.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.identifier)
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        //Retrieve movies from JSON network call
        downloadUpcomingMovies()
        downloadPopularMovies()
        downloadNowShowingMovies()
        
        //Create dataSource and reload once all the movie types have finished downloading
        dispatchGroup.notify(queue: .main) {
            self.createDataSource()
            self.reloadData()
        }
        
    }
   
    //MARK: Dark mode ui adjustments: https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("traitCollectionDidChange")
    }
    
    private func setupSearchButton() {
        self.view.addSubview(searchBtn)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        
        searchBtn.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: -25).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor,constant: -12).isActive = true
        searchBtn.widthAnchor.constraint(equalToConstant: 55).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    private func downloadUpcomingMovies() {
        dispatchGroup.enter()
        tmdbManager.tmdbRequest(UpcomingResults.self, endPoint: .getUpcoming) { [weak self] (result) in
            defer { self?.dispatchGroup.leave() }
            
            switch result {
            case .success(let result):
                self?.upcomingMovies = result.results
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }
    
    private func downloadPopularMovies() {
        //MARK: Retrieve Popular Movies
        dispatchGroup.enter()
        tmdbManager.tmdbRequest(PopularResults.self, endPoint: .getPopular) { [weak self] (result) in
            defer { self?.dispatchGroup.leave() }
            
            switch result {
            case .success(let result):
                self?.popularMovies = result.results
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }
    
    private func downloadNowShowingMovies() {
        //MARK: Retrieve Now Playing Movies
        dispatchGroup.enter()
        tmdbManager.tmdbRequest(NowPlayingResults.self, endPoint: .getNowPlaying) { [weak self] (result) in
            defer { self?.dispatchGroup.leave() }
            
            switch result {
            case .success(let result):
                self?.nowPlayingMovies = result.results
            case .failure(let error):
                print("Upcoming error: \(error.errorMessage)")
            }
        }
    }
    
    //MARK: createDataSource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieStatus, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCell.identifier, for: indexPath) as? MediaCell else { fatalError("Cannot create new cell") }
            
            movieCell.movie = movie
            return movieCell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            
            sectionHeader.title.text = "Not Assigned"
            
            guard let firstMovie = self?.dataSource?.itemIdentifier(for: indexPath) else { return sectionHeader }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstMovie) else { return sectionHeader }

            sectionHeader.title.text = section.rawValue
            return sectionHeader
        }
    }
    
    func reloadData() {
        //MovieStatus being the section object and Movie being the type of objects being supplied
        var snapshot = NSDiffableDataSourceSnapshot<MovieStatus, Movie>()
        snapshot.appendSections(movieStatues)
        
        guard let upcomingMovies = upcomingMovies?.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! }) else { return }
        snapshot.appendItems(upcomingMovies, toSection: .upcoming)
        
        guard let popularMovies = popularMovies?.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! }) else { return }
        snapshot.appendItems(popularMovies, toSection: .popular)
        
        guard let nowPlayingMovies = nowPlayingMovies?.sorted(by: { $0.releaseDateObject! > $1.releaseDateObject! }) else { return }
        snapshot.appendItems(nowPlayingMovies, toSection: .nowPlaying)
        
        dataSource?.apply(snapshot)
    }
    
    
    //MARK: createCompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.movieStatues[sectionIndex]
            
            return self.createSections(using: section)
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15  //this determines how far apart the sections are
        layout.configuration = config
        return layout
    }
    
    func createSections(using section: MovieStatus) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))  //full height and width of parent, group
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250)) //using approx here cause some of the titles to now show despite having plenty of room to show
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedMovie = dataSource?.itemIdentifier(for: indexPath)
        guard let movie = tappedMovie else { return }
        print("\(String(describing: movie.title)), movieID: \(String(describing: movie.id)), date: \(String(describing: movie.releaseDate))")
        
        let movieDetailVC = MovieDetailVC()
        movieDetailVC.passedMovieID = String(movie.id ?? 0)
        movieDetailVC.modalPresentationStyle = .fullScreen
        self.present(movieDetailVC, animated: true, completion: nil)
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
}

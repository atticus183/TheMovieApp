//
//  MediaCVC.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Combine
import UIKit

final class MediaCVC: UICollectionViewController {

    private var cancellables: Set<AnyCancellable> = []

    private let viewModel = MediaCVCViewModel()

    private var dataSource: UICollectionViewDiffableDataSource<MovieStatus, Movie>?

    private let movieStatues = MovieStatus.allCases

    private lazy var searchBtn: SearchButton = {
        let button = SearchButton()
        button.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = .systemBackground
        setupSearchButton()

        //MARK: Setup collectionView
        //CollectionView elements registration
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(MediaCell.self,
                                forCellWithReuseIdentifier: MediaCell.identifier)
        collectionView.collectionViewLayout = createCompositionalLayout()

        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.updateAndCreateDatasource()
            }.store(in: &cancellables)
    }

    // MARK: Methods

    @objc func searchBtnTapped() {
        let searchVC = SearchVC()
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }

    //MARK: Dark mode ui adjustments: https://developer.apple.com/documentation/xcode/supporting_dark_mode_in_your_interface
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//    }

    private func setupSearchButton() {
        view.addSubview(searchBtn)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBtn.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -25),
            searchBtn.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor,constant: -12),
            searchBtn.widthAnchor.constraint(equalToConstant: 55),
            searchBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
    }

    private func updateAndCreateDatasource() {
        createDataSource()
        reloadData()
    }

    //MARK: createDataSource
    private func createDataSource() {
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

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieStatus, Movie>()
        snapshot.appendSections(movieStatues)
        snapshot.appendItems(viewModel.upcomingMovies, toSection: .upcoming)
        snapshot.appendItems(viewModel.popularMovies, toSection: .popular)
        snapshot.appendItems(viewModel.nowPlayingMovies, toSection: .nowPlaying)
        dataSource?.apply(snapshot)
    }

    //MARK: createCompositionalLayout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.movieStatues[sectionIndex]
            return self.createSections(using: section)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15  //this determines how far apart the sections are
        layout.configuration = config
        return layout
    }

    private func createSections(using section: MovieStatus) -> NSCollectionLayoutSection {
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

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}

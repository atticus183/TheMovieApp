//
//  MovieDetailTVC.swift
//  TheMovieApp
//
//  Created by Josh R on 1/4/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import SwiftUI  //used for live refresh only

class MovieDetailVC: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    
    lazy var tmdbManager = TMDbManager()
    
    var passedMovieID = "330457"  //default value for SwiftUI preview
    
    var movie: Movie?
    var movieReleaseDates: [ReleaseDate]?
    
    let bannerImgView = UIImageView()
    let postImgView = UIImageView()
    
    lazy var movieTitleLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.text = "Title Label"
        
        return label
    }()
    
    lazy var movieRatingLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.minimumScaleFactor = 0.5
        label.text = "Rating"
        
        return label
    }()
    
    lazy var genreLbl: UILabel = {
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
    
    lazy var releaseDateSV: ReleaseDateSV = {
        let sv = ReleaseDateSV()
        return sv
    }()
    
    lazy var summaryLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 10
        label.text = "Summary..."
        
        return label
    }()
    
    lazy var closeBtn: CloseBtn = {
        let button = CloseBtn()
        button.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc func closeBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray6  //use systemGray6 or systemBackground
        addViewsToVC()
        addViewConstraints()
        
        movieTitleLbl.text = "Title Label"
        summaryLbl.text = "Summary...Summary...Summary..."

        dispatchGroup.enter()
        tmdbManager.tmdbRequest(Movie.self, endPoint: .getDetails(passedMovieID)) { [weak self] (result) in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.dispatchGroup.leave()
            case .failure(let error):
                print("Movie detail error: \(error.localizedDescription)")
            }
        }
        
        //MARK: Retrieve Release Dates and rating
        dispatchGroup.enter()
        tmdbManager.tmdbRequest(MovieReleaseDateResult.self, endPoint: .getReleaseDates(passedMovieID)) { [weak self] (result) in
            switch result {
            case .success(let movieReleaseDateResult):
                self?.movieReleaseDates = movieReleaseDateResult.unitedStatesReleaseDates
                self?.dispatchGroup.leave()
            case .failure(let error):
                print("Movie release date error: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Dispatch group notified")
            self.loadViews()
        }
    }

    
    private func addViewsToVC() {
        bannerImgView.contentMode = .scaleAspectFit
        postImgView.contentMode = .scaleAspectFit
        
        self.view.addSubview(bannerImgView)
        self.view.addSubview(postImgView)
        self.view.addSubview(movieTitleLbl)
        self.view.addSubview(movieRatingLbl)
        self.view.addSubview(genreLbl)
        self.view.addSubview(releaseDateSV)
        self.view.addSubview(summaryLbl)
        self.view.addSubview(closeBtn)
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
        
        bannerImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        bannerImgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -12).isActive = true
        bannerImgView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: 12).isActive = true
        bannerImgView.heightAnchor.constraint(equalToConstant: 235).isActive = true
        
        postImgView.topAnchor.constraint(equalTo: bannerImgView.bottomAnchor, constant: -50).isActive = true
        postImgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        
        postImgView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        postImgView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        movieTitleLbl.topAnchor.constraint(equalTo: bannerImgView.bottomAnchor, constant: 2).isActive = true
        movieTitleLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5).isActive = true
        movieTitleLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        movieRatingLbl.topAnchor.constraint(equalTo: movieTitleLbl.bottomAnchor, constant: 2).isActive = true
        movieRatingLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5).isActive = true
        
        genreLbl.topAnchor.constraint(equalTo: movieRatingLbl.bottomAnchor, constant: 2).isActive = true
        genreLbl.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5).isActive = true
        genreLbl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        //SV contains all the release date labels
        releaseDateSV.topAnchor.constraint(equalTo: genreLbl.bottomAnchor, constant: 2).isActive = true
        releaseDateSV.leadingAnchor.constraint(equalTo: postImgView.trailingAnchor, constant: 5).isActive = true
        
        summaryLbl.topAnchor.constraint(equalTo: postImgView.bottomAnchor, constant: 20).isActive = true
        summaryLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        summaryLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        
        closeBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        closeBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: closeBtn.frame.height).isActive = true
      
    }
    
    //Used to set details after the movie is retrieved
    private func loadViews() {
        guard let movie = movie else { return }
        
        let backdropURL = URL(string: movie.retrieveImgURLString(with: .backdropW1280))
        bannerImgView.kf.setImage(with: backdropURL)
        
        let posterURL = URL(string: movie.retrieveImgURLString(with: .posterW154))
        postImgView.kf.setImage(with: posterURL)
        
        movieTitleLbl.text = movie.title
        movieRatingLbl.text = movieReleaseDates?.first?.certification ?? "No Rating"
        genreLbl.text = movie.genresString
        
        let theaterReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .theatrical, in: movieReleaseDates)
        releaseDateSV.theaterReleaseDateLbl.text = "Theatrical: \(DateFormatters.convertZTime(zStringDate: theaterReleaseDate))"
        let digitalReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .digital, in: movieReleaseDates)
        releaseDateSV.digitalReleaseDateLbl.text = "Digital: \(DateFormatters.convertZTime(zStringDate: digitalReleaseDate))"
        let physicalReleaseDate = ReleaseDate.retrieveReleaseDate(byType: .physical, in: movieReleaseDates)
        releaseDateSV.physicalReleaseDateLbl.text = "Physical: \(DateFormatters.convertZTime(zStringDate: physicalReleaseDate))"
        
        summaryLbl.text = movie.overview ?? "No Summary Available"
    }
    
}


//MARK: SwiftUI setup to allow preview updates with UIKit
//NOTE:  The use of fileprivate is so you don't have to create new struct names each file you use this in
//Steps to copy this to another file:
    //change VC the typealias is referring to
    //change the name of the PreviewProvider struct below to something unique

fileprivate typealias ThisViewController = MovieDetailVC //update to this file's VC

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
struct MovieDetailVC_ContentView_Preview: PreviewProvider {
    static var previews: some View {
        SecondContentView()  //if preview isn't changing, change this struct to the struct conforming to View
    }
}

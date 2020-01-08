//
//  SearchCell.swift
//  TheMovieApp
//
//  Created by Josh R on 1/6/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    var movie: SearchedMovie? {
        didSet {
            guard let movie = movie else { return }
            mediaTitleLbl.text = movie.title?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let posterURL = URL(string: MovieHelper.retrieveImg(path: movie.posterPath ?? "", withSize: MovieHelper.posterW500))
            posterImgView.kf.setImage(with: posterURL)
            
            genreLbl.text = Genre.retrieveGenreTextString(ids: movie.genreIds)
            releaseDateLbl.text = DateFormatters.changeStringDateFormat(from: movie.releaseDate ?? "")
        }
    }
    
    static let cellID = "SearchCell"
    
    lazy var posterImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        
        return imgView
    }()
    
    lazy var mediaTitleLbl: UILabel = {
        let label = UILabel()
        label.text = "Movie Title"
        label.textColor = .label  //.label is a dynamic color and with change with dark and light mode
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var genreLbl: UILabel = {
        let label = UILabel()
        label.text = "Genre"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left

        return label
    }()
    
    lazy var releaseDateLbl: UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        
        return label
    }()
    
    let vTextStackView = UIStackView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        vTextStackView.axis = .vertical
//        vTextStackView.distribution = .fillEqually
        vTextStackView.spacing = 4
        vTextStackView.addArrangedSubview(mediaTitleLbl)
        vTextStackView.addArrangedSubview(genreLbl)
        vTextStackView.addArrangedSubview(releaseDateLbl)
        
        addViews(views: posterImgView, vTextStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews(views: UIView...) {
        views.forEach({ self.contentView.addSubview($0) })
    }
    
    private func setConstraints() {
        posterImgView.translatesAutoresizingMaskIntoConstraints = false
        vTextStackView.translatesAutoresizingMaskIntoConstraints = false
        
        posterImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        posterImgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        posterImgView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
        posterImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        vTextStackView.topAnchor.constraint(equalTo: posterImgView.topAnchor, constant: 0).isActive = true
        vTextStackView.leadingAnchor.constraint(equalTo: posterImgView.trailingAnchor, constant: 8).isActive = true
        vTextStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5).isActive = true
    }

}

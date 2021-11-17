//
//  MediaCell.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

final class MediaCell: UICollectionViewCell {

    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            mediaTitleLbl.text = movie.title?.trimmingCharacters(in: .whitespacesAndNewlines)

            let posterURL = URL(string: movie.retrieveImgURLString(with: .posterW500))
            imgView.kf.setImage(with: posterURL)
            releaseDateLbl.text = movie.releaseDateFormatted
        }
    }

    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

    lazy var mediaTitleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    lazy var releaseDateLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    let stackView = UIStackView()

    private func setupCell() {
        contentView.backgroundColor = .clear

        stackView.axis = .vertical
        stackView.addArrangedSubview(imgView)
        stackView.addArrangedSubview(mediaTitleLbl)
        stackView.addArrangedSubview(releaseDateLbl)

        addViewsToCell(stackView)
        setupConstraints()
    }

    private func addViewsToCell(_ views: UIView...) {
        contentView.addSubview(stackView)
        views.forEach({ self.contentView.addSubview($0) })
    }

    private func setupConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        imgView.heightAnchor.constraint(equalToConstant: 215).isActive = true  //43% of the retrieved width seems to allow the poster to fit perfectly without cutting off the title

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 0).isActive = true
    }
}

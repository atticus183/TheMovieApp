//
//  ReleaseDateSV.swift
//  TheMovieApp
//
//  Created by Josh R on 1/5/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit

class ReleaseDateSV: UIStackView {
    
    //MARK:  Get all release dates: https://developers.themoviedb.org/3/movies/get-movie-release-dates
    lazy var theaterReleaseDateLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.text = "Theater"
        
        return label
    }()
    
    lazy var digitalReleaseDateLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.text = "Digital"
        
        return label
    }()
    
    lazy var physicalReleaseDateLbl: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.text = "Physical"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.spacing = 4
        self.distribution = .fill
        
        self.addArrangedSubview(theaterReleaseDateLbl)
        self.addArrangedSubview(digitalReleaseDateLbl)
        self.addArrangedSubview(physicalReleaseDateLbl)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

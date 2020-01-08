//
//  SearchButton.swift
//  TheMovieApp
//
//  Created by Josh R on 1/3/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit

class SearchButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let searchIcon = UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.backgroundColor = .systemBlue
        self.giveRoundCorners()
        self.setImage(searchIcon, for: .normal)
        
        //button shadow
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset.height = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

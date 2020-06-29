//
//  CloseBtn.swift
//  TheMovieApp
//
//  Created by Josh R on 1/7/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit

class CloseBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        self.backgroundColor = .darkGray
        self.setTitle("Close", for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

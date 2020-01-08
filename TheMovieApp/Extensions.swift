//
//  Extensions.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import UIKit


//MARK: UICollectionViewCell
extension UICollectionViewCell{
    class var identifier: String {
        return String(describing: self)
    }
}

//MARK: UIView
extension UIView {
    func roundCorners(by value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    func giveRoundCorners() {
        self.layer.cornerRadius = self.layer.frame.height / 2
//        self.layer.masksToBounds = true
    }
}

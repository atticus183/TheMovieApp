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
    }
}


extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping (T) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Invalid URL passed.")
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let downloadedData = try self.decode(type, from: data)
                
                DispatchQueue.main.async {
                    completion(downloadedData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

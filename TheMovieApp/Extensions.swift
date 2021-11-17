//
//  Extensions.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

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

//MARK: UIView
extension UIView {
    func roundCorners(by value: CGFloat) {
        self.layer.cornerRadius = value
    }

    func giveRoundCorners() {
        self.layer.cornerRadius = self.layer.frame.height / 2
    }
}

//MARK: UIViewController
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}

//MARK: UICollectionViewCell
extension UICollectionViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

//MARK: UITableViewCell
extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

//
//  QuickActions.swift
//  TheMovieApp
//
//  Created by Josh R on 6/28/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Foundation
import UIKit

struct QuickActions {
    static let search = "com.joshr.TheMovieApp.search"
    
    static func performAction(for shortcutItem: UIApplicationShortcutItem, in window: UIWindow?) {
        guard let window = window else { return }
        switch shortcutItem.type {
        case search:
            let searchVC = SearchVC()
            searchVC.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(searchVC, animated: true, completion: nil)
        default:
            break
        }
    }
}

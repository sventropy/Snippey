//
//  StyleController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
import UIKit

/// Controller providing class level functions to apply consistent styling to the application and keyboard extension
class StyleController {

    // MARK: - Class level styling functions

    /// Applies style to all relevant UIKit controls using UIAppearance
    class func applyStyle() {

        // tint
        UIWindow.appearance().tintColor = Constants.accentColor

        // tableview
        UITableView.appearance().backgroundColor = Constants.mediumColor
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().contentInset = UIEdgeInsets(top: Constants.margin / 2, left: CGFloat.zero, bottom: Constants.margin / 2, right: CGFloat.zero)

        // nav bar
        UINavigationBar.appearance().tintColor = Constants.accentColor
        UINavigationBar.appearance().barTintColor = Constants.darkColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.accentColor]

        // text view
        UITextView.appearance().backgroundColor = Constants.lightColor
        UITextView.appearance().textColor = Constants.textColor
    }

    /// Applies style to all relevant aspects of a given UITableViewCell. This is not done via UIAppearance since components
    /// like the contentView of the tableViewCell are to cumbersome to style that way
    class func applyCellStyle(tableViewCell: UITableViewCell, isDark: Bool) {

        tableViewCell.backgroundColor = .clear
        tableViewCell.textLabel?.textColor = isDark ? Constants.lightColor : Constants.textColor
        tableViewCell.textLabel?.textAlignment = .left
        tableViewCell.contentView.backgroundColor = isDark ? Constants.darkColor : Constants.lightColor
        tableViewCell.contentView.layer.cornerRadius = Constants.cornerRadius
        tableViewCell.contentView.layer.shadowColor = isDark ? UIColor.black.cgColor : Constants.darkColor.cgColor
        tableViewCell.contentView.layer.shadowOpacity = Constants.shadowOpacity
        tableViewCell.contentView.layer.shadowOffset = Constants.shadowOffset
    }
    
    class func loadIconResized(assetName: String) -> UIImage {
        guard let image = UIImage(named: assetName) else { return UIImage() }
        return image.resized(to: CGSize(width: 44, height: 44))
    }
}

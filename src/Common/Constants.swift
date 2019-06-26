//
//  Constants.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
import UIKit

/// Collection of constants used throughout the app and keyboard extension
struct Constants {

    // Strings
    static let cellReuseIdentifier = "snippetCell"
    static let appGroup = "group.de.sventropy.app.snippey"
    static let defaultsSnippetsKey = "snippets"
    static let defaultsTutorialKey = "hasSeenTutorial"
    static let infoCellReuseIdentifier = "infoCell"
    static let infoHeaderViewReuseIdentifier = "infoHeaderView"
    static let appleKeyboardDefaultsKey = "AppleKeyboards"
    static let snippeyKeyboardBundleId = "de.sventropy.app.Snippey.SnippeyKeyboard"
    static let switchAssertionFailureMessage = "UITableView misconfigured!"
    static let urlSnippeyPrivacyPolicy = "https://github.com/sventropy/Snippey-Privacy-Policy"
    static let urlSnippeyDevGitHub = "https://github.com/sventropy"
    static let urlSwiftReorderGitHub = "https://github.com/adamshin/SwiftReorder"

    // UI Magic Numbers
    static let cornerRadius: CGFloat = 4.0
    static let textAreaSideInset: CGFloat = 5.0
    static let textAreaTopBottomInset: CGFloat = 8.0
    static let textAreaDefaultHeight: CGFloat = 320.0
    static let toolbarHeight: CGFloat = 48.0
    static let keyboardHeightIPhone: CGFloat = 258.0
    static let keyboardHeightIPhoneX: CGFloat = 333.0
    static let margin: CGFloat = 8.0
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: 1, height: 2)
    static let cellBorderWidth: CGFloat = 1
    static let snippetMaximumNumberOfLines = 5

    // Constaints
    static let maximumSnippetLength: Int = 200

    // Colors
    static var accentColor: UIColor { return UIColor(hexString: "#6DD48E") }
    static var darkColor: UIColor { return UIColor(hexString: "#353535") }
    static var lightColor: UIColor { return UIColor(hexString: "#FFFFFF") }
    static var mediumColor: UIColor { return UIColor(hexString: "#D8D8D8") }
    static var errorColor = UIColor.red
    // Not applied yet to table view action due to effort (no official API)
    //    var deleteColor : UIColor { return UIColor(hexString: "#A10D00")}
    static var textColor: UIColor { return darkColor }
    static var placeholderColor: UIColor {return mediumColor }

}

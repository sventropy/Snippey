//
//  Constants.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
import UIKit

// MARK: Constants

struct Constants {
    
    // Strings
    static let cellReuseIdentifier = "snippetCell"
    static let appGroup = "group.de.sventropy.app.snippey"
    static let defaultsSnippetsKey = "snippets"
    
    // UI Magic Numbers
    static let cornerRadius : CGFloat = 4.0
    static let textAreaSideInset : CGFloat = 5.0
    static let textAreaTopBottomInset : CGFloat = 8.0
    static let textAreaDefaultHeight : CGFloat = 320.0
    static let toolbarHeight : CGFloat = 48.0
    static let keyboardHeightIPhone : CGFloat = 258.0
    static let keyboardHeightIPhoneX : CGFloat = 333.0
    static let margin : CGFloat = 8.0
    static let shadowOpacity : Float = 0.5
    static let shadowOffset = CGSize(width: 1, height: 2)
    
    // Constaints
    static let maximumSnippetLength : Int = 200
    
    // Colors
    static var accentColor : UIColor { return UIColor(hexString: "#6DD48E") }
    static var darkColor  : UIColor { return UIColor(hexString: "#353535") }
    static var lightColor  : UIColor { return UIColor(hexString: "#FFFFFF") }
    static var mediumColor : UIColor { return UIColor(hexString: "#D8D8D8") }
    // Not applied yet to table view action due to effort (no official API)
    //    var deleteColor : UIColor { return UIColor(hexString: "#A10D00")}
    static var textColor : UIColor { return darkColor }
    static var placeholderColor : UIColor {return mediumColor }
    
    // Styling
    static func applyStyle(window: UIWindow) {
        
        // tint
        window.tintColor = accentColor
        
        // backround
        UITableView.appearance().backgroundColor = mediumColor
        UINavigationBar.appearance().barTintColor = darkColor
        UITableViewCell.appearance().backgroundColor = mediumColor
        UIView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = lightColor
        UITextView.appearance().backgroundColor = lightColor
        
        // text
        UITextView.appearance().textColor = textColor
        UILabel.appearance().textColor = textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: accentColor]
        
        // keyboard
        UITextField.appearance().keyboardAppearance = .light
    }
}

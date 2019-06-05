//
//  Style.swift
//  Snippey
//
//  Created by Hennessen, Sven on 04.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class Style {
    
    static let sharedInstance = Style()
    
    private init() {
        // Singleton
    }
    
    var accentColor : UIColor { return UIColor(hexString: "#6DD48E") }
    var darkColor  : UIColor { return UIColor(hexString: "#353535") }
    var lightColor  : UIColor { return UIColor(hexString: "#FFFFFF") }
    var mediumColor : UIColor { return UIColor(hexString: "#D8D8D8") }
    // Not applied yet to table view action due to effort (no official API)
//    var deleteColor : UIColor { return UIColor(hexString: "#A10D00")}
    
    // Color redirects
    var viewBackgroundColor : UIColor { return lightColor }
    var textColor : UIColor { return darkColor }
    var placeholderColor : UIColor {return mediumColor }
    
    func apply(window: UIWindow) {
        
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

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
    
    var primaryTintColor : UIColor { return UIColor(hexString: "#408355") }
    var secondaryTintColor : UIColor { return UIColor(hexString: "#284B63") }
    var darkColor  : UIColor { return UIColor(hexString: "#353535") }
    var lightColor  : UIColor { return UIColor(hexString: "#ffffff") }
    var mediumColor : UIColor { return UIColor(hexString: "#d9d9d9") }
    
    // Color redirects
    var viewBackgroundColor : UIColor { return lightColor }
    var textColor : UIColor { return darkColor }
    var placeholderColor : UIColor {return lightColor }
    
    func apply(window: UIWindow) {
        
        // tint
        window.tintColor = secondaryTintColor
        
        // backround
        UITableView.appearance().backgroundColor = mediumColor
        UINavigationBar.appearance().barTintColor = primaryTintColor
        UITableViewCell.appearance().backgroundColor = mediumColor
        UIView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).backgroundColor = lightColor
        UITextView.appearance().backgroundColor = lightColor
        
        // text
        UITextView.appearance().textColor = secondaryTintColor
        UILabel.appearance().textColor = darkColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: lightColor]
        
        // Accents
        // TODO
//        UIView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).layer.borderColor = darkColor.cgColor
//        UIView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).layer.borderWidth = 2
        
        // keyboard
        UITextField.appearance().keyboardAppearance = .light
        
    }
}

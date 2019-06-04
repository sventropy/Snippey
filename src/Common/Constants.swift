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
    static let cellReuseIdentifier = "snippetCell"
    static let cornerRadius : CGFloat = 4.0
    static let keyboardBackgroundColor = UIColor(displayP3Red: 199/255, green: 203/255, blue: 210/255, alpha: 1)
    static let buttonBackgroundColor = UIColor.white
    static let textColor = UIColor.black
    static let placeholderColor = UIColor.lightGray
    static let appGroup = "group.de.sventropy.app.snippey"
    static let defaultsSnippetsKey = "snippets"
    static let textAreaSideInset : CGFloat = 5.0
    static let textAreaTopBottomInset : CGFloat = 8.0
    static let textAreaDefaultHeight : CGFloat = 320.0
    static let toolbarHeight : CGFloat = 48.0
    static let keyboardHeightIPhone : CGFloat = 258.0
    static let keyboardHeightIPhoneX : CGFloat = 333.0
    static let margin : CGFloat = 8.0
}

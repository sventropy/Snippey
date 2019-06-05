//
//  RootNavigationController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 05.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

// Override UINavigationController to apply status bar style
class RootNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // The navigation bar tint and hence status bar background is always dark
        return .lightContent
    }
    
}

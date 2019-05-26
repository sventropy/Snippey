//
//  Util.swift
//  Snippey
//
//  Created by Hennessen, Sven on 26.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static func printViewsIntrinsicSizeRecursive(views:[UIView]!) {
        
        if(views.count == 0){ return }
        
        for v in views {
            print("View:", String(describing: v), "|w:",v.intrinsicContentSize.width, "|h:",v.intrinsicContentSize.height)
            printViewsIntrinsicSizeRecursive(views: v.subviews)
        }
    }
    
    static func findFirstSubviewOfTypeRecursive<T>(view: UIView, targetType: T.Type) -> T? {
        
        if (view is T) { return view as? T }
        
        for subView in view.subviews {
            if let targetView = findFirstSubviewOfTypeRecursive(view: subView, targetType: targetType) {
                return targetView
            }
        }
        
        return nil
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
}

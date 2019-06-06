//
//  String+Localized.swift
//  Snippey
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

/// String extension providing property to access localized representation of the string, if localized version exists in Localizable.strings
extension String {
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
}

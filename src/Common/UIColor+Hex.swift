//
//  UIColor+Hex.swift
//  Snippey
//
//  Created by Hennessen, Sven on 04.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// UIColor extension enabling transformation of HEX color code strings to UIColor via a convenience initializer
/// Found on https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
extension UIColor {

    convenience init(hexString: String) {
        let hexcolorString = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var integer = UInt32()
        Scanner(string: hexcolorString).scanHexInt32(&integer)
        let alpha, red, green, blue: UInt32
        switch hexcolorString.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (integer >> 8) * 17, (integer >> 4 & 0xF) * 17, (integer & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, integer >> 16, integer >> 8 & 0xFF, integer & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (integer >> 24, integer >> 16 & 0xFF, integer >> 8 & 0xFF, integer & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }
}

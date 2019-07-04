//
//  UIImage+Resiized.swift
//  Snippey
//
//  Created by Hennessen, Sven on 04.07.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit


extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

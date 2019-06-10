//
//  Util.swift
//  Snippey
//
//  Created by Hennessen, Sven on 10.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
import UIKit

class Util {

    class func openUrl(urlString: String) {
        print("Opening URL \(urlString)")
        guard let parsedUrl = URL(string: urlString) else {
            print("URL could not be parsed")
            return
        }
        if !UIApplication.shared.canOpenURL(parsedUrl) {
            print("URL could not be opened")
            return
        }

        UIApplication.shared.open(parsedUrl, options: [:], completionHandler: nil)
    }
}

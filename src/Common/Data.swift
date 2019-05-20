//
//  Data.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

class Data {
    
    static let sharedInstance = Data()
    
    func initializeDefaultSnippets() {
        let defaults = UserDefaults(suiteName: Constants.appGroup)
        var data = defaults?.dictionary(forKey: "data")
        if (data == nil) {
            data = ["shrug": "¯\\_(ツ)_/¯", "why": "щ（ﾟДﾟщ）", "fuck": "t(-_-t)"]
            defaults?.set(data, forKey: "data")
        }
    }
    
    func loadSnippets() -> [Snippet] {
        
        // Initialize defaults for app group
        let defaults = UserDefaults(suiteName: Constants.appGroup)
        
        // Initialize result
        var snippets : [Snippet] = []
        
        // Load data from defaults
        let snippetData = defaults?.dictionary(forKey: "data")
        if let snippetDict = snippetData {
            for e in snippetDict {
                snippets.append(Snippet(title: e.value as! String, text: e.key))
            }
        }
        return snippets
    }
}

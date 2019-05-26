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
    var defaults: UserDefaults? {
        // Initialize defaults for app group
        return UserDefaults(suiteName: Constants.appGroup)
    }
    
    func initializeDefaultSnippets() {

        // Check for existing snippets
        guard (defaults?.data(forKey: Constants.defaultsSnippetsKey)) != nil
            else {
                // Store default snippets (once)
                let defaultSnippets = [Snippet(title: "shrug", text: "¯\\_(ツ)_/¯") , Snippet(title: "why", text: "щ（ﾟДﾟщ）"), Snippet(title: "fuck", text: "t(-_-t)")]
                storeSnippets(snippets: defaultSnippets)
                return
            }
    }
    
    func loadSnippets() -> [Snippet] {

        // Load data from defaults
        guard let snippetArrayData = defaults?.data(forKey: Constants.defaultsSnippetsKey)
            else { return [Snippet]() } // return empty result
        
        // Convert snippets to model
        return try! PropertyListDecoder().decode([Snippet].self, from: snippetArrayData)
    }
    
    func storeSnippets(snippets: [Snippet]) {
        
        // Store new list of snippets (always entire list --> easier, shouldn't be an issue performance wise)
        let snippetArrayData = try! PropertyListEncoder().encode(snippets)
        defaults?.set(snippetArrayData, forKey: Constants.defaultsSnippetsKey)
    }
}

//
//  Data.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

/// Wrapper for all data access for both app and keyboard extension
class Data {
    
    //MARK: - Properties
    
    static let sharedInstance = Data()
    var defaults: UserDefaults? {
        // Initialize defaults for app group
        return UserDefaults(suiteName: Constants.appGroup)
    }
    
    /// Creates the default set of snippets to populate the app and keyboard with and triggers storing it in the appgroup's user defaults
    func initializeDefaultSnippets() {
        
        print("Loading default snippets, if none exist")

        // Check for existing snippets, not required, only for unwrapping
        guard (defaults?.data(forKey: Constants.defaultsSnippetsKey)) != nil
            else {
                // Store default snippets (once)
                let defaultSnippets = [Snippet(text: "¯\\_(ツ)_/¯") , Snippet(text: "щ（ﾟДﾟщ）"), Snippet(text: "t(-_-t)")]
                storeSnippets(snippets: defaultSnippets)
                print("\(defaultSnippets.count) snippets stored")
                
                return
            }
        
        // Not loaded defaults, check found default snippets
        print("Existing snippets found. Did not store default snippets")
    }
    
    /// Reads all stored snippets from the appgroup's userdefaults
    func loadSnippets() -> [Snippet] {
        
        print("Loading stored snippets")

        // Load data from defaults
        guard let snippetArrayData = defaults?.data(forKey: Constants.defaultsSnippetsKey)
            else {
                print("No data found")
                // return empty result
                return [Snippet]()
        }
        
        // Convert snippets to model
        let snippets = try! PropertyListDecoder().decode([Snippet].self, from: snippetArrayData)
        print("\(snippets.count) snippets loaded")
        return snippets
    }
    
    /// Stores the given set of snippets in the appgroup's userdefaults
    func storeSnippets(snippets: [Snippet]) {
        
        print("Storing \(snippets.count) snippets")
        
        // Store new list of snippets (always entire list --> easier, shouldn't be an issue performance wise)
        let snippetArrayData = try! PropertyListEncoder().encode(snippets)
        defaults?.set(snippetArrayData, forKey: Constants.defaultsSnippetsKey)
        
        print("Snippets stored")
    }
}

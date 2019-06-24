//
//  Data.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

/// Protocol for data access
protocol DataAccessProtocol {
    func loadSnippets() -> [Snippet]
    func storeSnippets(snippets: [Snippet])
    func resetSnippets()
    func hasSeenTutorial() -> Bool
    func storeHasSeenTutorial(hasSeenTutorial: Bool)
}

/// Wrapper for all data access for both app and keyboard extension
class DataAccess: DataAccessProtocol {

    // MARK: - Properties

    private var defaults: UserDefaults? = UserDefaults(suiteName: Constants.appGroup)

    // MARK: - DataAccess Protocol API

    /// Reads all stored snippets from the appgroup's userdefaults
    func loadSnippets() -> [Snippet] {

        print("Loading stored snippets")

        var snippets: [Snippet]?
        if let snippetArrayData = defaults?.data(forKey: Constants.defaultsSnippetsKey) {
            // Convert snippets to model
            snippets = try? PropertyListDecoder().decode([Snippet].self, from: snippetArrayData)
        } else {
            snippets = [Snippet]()
        }

        print("\(snippets!.count) snippets loaded")
        return snippets!
    }

    /// Stores the given set of snippets in the appgroup's userdefaults
    func storeSnippets(snippets: [Snippet]) {

        print("Storing \(snippets.count) snippets")

        // Store new list of snippets (always entire list --> easier, shouldn't be an issue performance wise)
        let snippetArrayData = try? PropertyListEncoder().encode(snippets)
        defaults?.set(snippetArrayData, forKey: Constants.defaultsSnippetsKey)

        print("Snippets stored")
    }

    /// Deletes all snippets stored in the user defaults
    func resetSnippets() {
        print("Deleting all snippets")
        defaults?.removeObject(forKey: Constants.defaultsSnippetsKey)
    }
    
    /// Determines whether the tutorial was already completed
    func hasSeenTutorial() -> Bool {
        print("Checking whether tutorial is required")
        let hasSeenTutorial = defaults?.bool(forKey: Constants.defaultsTutorialKey)
        let result = hasSeenTutorial != nil && hasSeenTutorial!
        print("Tutorial already completed: \(result)")
        return result
    }
    
    /// Updates the status whether the tutorial was already completed
    func storeHasSeenTutorial(hasSeenTutorial: Bool) {
        print("Storing tutorial completion status \(hasSeenTutorial)")
        defaults?.set(hasSeenTutorial, forKey: Constants.defaultsTutorialKey)
    }
}

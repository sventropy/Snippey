//
//  Data.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

/// Protocol for data access
protocol DataAccess {
    func loadSnippets() -> [Snippet]
    func storeSnippets(snippets: [Snippet])
    func resetSnippets()
}

/// Wrapper for all data access for both app and keyboard extension
class Data: DataAccess {

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
            // Initialize and load default snippets
            snippets = initializeDefaultSnippets()
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
         UserDefaults(suiteName: Constants.appGroup)?.removeObject(forKey: Constants.defaultsSnippetsKey)
    }

    // MARK: - Private

    /// Creates the default set of snippets to populate the app and keyboard with and triggers
    /// storing it in the appgroup's user defaults
    private func initializeDefaultSnippets() -> [Snippet] {

        print("Initializing default snippets")

        // Store default snippets (once)
        let defaultSnippets = [Snippet(text: "default-snippet-welcome-text".localized)]
        storeSnippets(snippets: defaultSnippets)
        print("\(defaultSnippets.count) snippets stored")

        return defaultSnippets
    }
}

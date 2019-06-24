//
//  TestDataAccess.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation
@testable import Snippey

class MockDataAccess: DataAccessProtocol {

    var testSnippets = [Snippet(text: "1"), Snippet(text: "2"),
                        Snippet(text: "3"), Snippet(text: "4"), Snippet(text: "5")]
    var storeSnippetsCalled = false
    var hasSeenTutorialBackStore = false

    func loadSnippets() -> [Snippet] {
        return testSnippets
    }

    func storeSnippets(snippets: [Snippet]) {
        storeSnippetsCalled = true
        testSnippets = snippets
    }

    func resetSnippets() {
        // Nothing to do here
    }
    
    func hasSeenTutorial() -> Bool {
        return hasSeenTutorialBackStore
    }
    
    func storeHasSeenTutorial(hasSeenTutorial: Bool) {
        hasSeenTutorialBackStore = hasSeenTutorial
    }
}

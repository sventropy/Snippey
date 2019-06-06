//
//  TestDataAccess.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import Foundation

class TestDataAccess : DataAccess {
    
    var testSnippets = [Snippet(text: "1"),Snippet(text: "2"),Snippet(text: "3"),Snippet(text: "4"),Snippet(text: "5")]
    
    func loadSnippets() -> [Snippet] {
        return testSnippets
    }
    
    func storeSnippets(snippets: [Snippet]) {
        // Nothing to do here
    }
}

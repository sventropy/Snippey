//
//  DataTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 10.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest
@testable import Snippey

class DataTests: XCTestCase {

    var data: DataAccess?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Ensure no data stored in user defaults (NOTE: Wrapping the userdefaults inside the datatype makes
        // this more of an integration test, than a unit test. However, I'll spare myself the effort to decouple
        // the two for now.)
        UserDefaults(suiteName: Constants.appGroup)?.removeObject(forKey: Constants.defaultsSnippetsKey)
        // Initialize instance
        data = DataAccess()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadSnippetsReflectsStoreSnippets() {

        data?.storeSnippets(snippets: [Snippet(text: "Stored snippet"), Snippet(text: "Stored snippet 2")])
        let snippets = data?.loadSnippets()
        XCTAssertNotNil(snippets)
        if let snippetArray = snippets {
            XCTAssertEqual(snippetArray.count, 2)
            XCTAssertEqual(snippetArray[0].text, "Stored snippet")
            XCTAssertEqual(snippetArray[1].text, "Stored snippet 2")
        }
    }

}

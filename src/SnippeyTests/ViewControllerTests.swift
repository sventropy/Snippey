//
//  ViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {
    
    var viewController : ViewController?
    var dataAccess : TestDataAccess?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = ViewController()
        dataAccess = TestDataAccess()
        viewController?.dataAccess = dataAccess
        viewController?.viewDidLoad()
        viewController?.viewWillAppear(true)
        viewController?.viewDidAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // test number of items displayed is correct
    func testNumberOfItemsInTableCorrect() {
        XCTAssertEqual(viewController!.tableView(viewController!.tableView, numberOfRowsInSection: 0), dataAccess!.testSnippets.count)
    }
    
    // test no items loaded
    func testNoItemsLoadedMessageDisplayed() {
        // Remove all test snippets before loading
        dataAccess!.testSnippets.removeAll()
        XCTAssertNotNil(viewController!.noSnippetsLabel)
        if let label = viewController!.noSnippetsLabel {
            XCTAssertFalse(label.isHidden)
        }
    }
}


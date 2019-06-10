//
//  KeyboardViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest

class KeyboardViewControllerTests: XCTestCase {

    var viewController: KeyboardViewController?
    var dataAccess: TestDataAccess?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = KeyboardViewController()
        dataAccess = TestDataAccess()
        viewController?.dataAccess = dataAccess!
        viewController?.viewDidLoad()
        viewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // test number of items displayed is correct
    func testNumberOfItemsInTableCorrect() {
        XCTAssertEqual(viewController!.tableView(viewController!.tableView, numberOfRowsInSection: 0),
                       dataAccess!.testSnippets.count)
    }

    func testNoItemsLoadedMessageDisplayed() {
        // Remove all test snippets before loading
        dataAccess!.testSnippets.removeAll()
        viewController?.viewWillAppear(true) // re-simulate trigger screen appearing

        XCTAssertNotNil(viewController!.tableView.backgroundView)
        if let label = viewController!.tableView.backgroundView {
            XCTAssertFalse(label.isHidden)
        }
    }

}

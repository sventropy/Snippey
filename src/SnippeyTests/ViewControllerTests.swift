//
//  ViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest
@testable import Snippey

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!
    var dataAccess: MockDataAccess!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = ViewController()
        // HACK: To make the window update viewcontroller properties on navigation/presentation as usual
        UIApplication.shared.keyWindow?.rootViewController = viewController
        dataAccess = MockDataAccess()
        viewController.dataAccess = dataAccess
        viewController.viewDidLoad()
        viewController.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfItemsInTableCorrect() {
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0),
                       dataAccess.testSnippets.count)
    }

    func testNoItemsLoadedMessageDisplayed() {
        // Remove all test snippets before loading
        dataAccess.testSnippets.removeAll()
        viewController.viewWillAppear(true) // re-simulate trigger screen appearing

        XCTAssertNotNil(viewController.tableView.backgroundView)
        if let label = viewController.tableView.backgroundView {
            XCTAssertFalse(label.isHidden)
        }
    }

    func testAddPressedAddSnippetViewControllerPresented() {
        viewController.addSnippet()
        // add snippet controller is wrapped in UINavigationController
        let navigationControllerPresented = viewController.presentedViewController is UINavigationController
        XCTAssertTrue(navigationControllerPresented)
        if navigationControllerPresented {
            if let navigationController = viewController.presentedViewController as? UINavigationController {
                XCTAssertTrue(navigationController.topViewController is AddSnippetViewController)
            }
        }
    }

    func testTableViewCellsNotSelectable() {
        XCTAssertFalse((viewController?.tableView.allowsSelection)!)
    }

    func testShowInfoPressedAInfoViewControllerPresented() {
        viewController.showInfo()
        // info controller is wrapped in UINavigationController
        let navigationControllerPresented = viewController.presentedViewController is UINavigationController
        XCTAssertTrue(navigationControllerPresented)
        if navigationControllerPresented {
            if let navigationController = viewController.presentedViewController as? UINavigationController {
                XCTAssertTrue(navigationController.topViewController is InfoTableViewController)
            }
        }
    }
    
    func testDidAddSnippetStoresSnippet() {
        let countBefore = dataAccess!.testSnippets.count
        viewController.didAddNewSnippet(snippetText: "TestSnippetText")
        XCTAssertTrue(dataAccess!.storeSnippetsCalled)
        let countAfter = dataAccess!.testSnippets.count
        XCTAssertEqual(countAfter, countBefore + 1)
    }
    
}

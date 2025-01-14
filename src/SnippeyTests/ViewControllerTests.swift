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

    var viewController: MockViewController!
    var dataAccess: MockDataAccess!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = MockViewController()
        // HACK: To make the window update viewcontroller properties on navigation/presentation as usual
        dataAccess = MockDataAccess()
        viewController.dataAccess = dataAccess
        UIApplication.shared.keyWindow?.rootViewController = viewController
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

    func testReorderDoesChangeSnippetPosition() {
        viewController.tableView(viewController.tableView, reorderRowAt: IndexPath(row: 1, section: 0), to: IndexPath(row: 2, section: 0))
        // Verify position change of "2" and "3"
        XCTAssertEqual(viewController.snippets[2].text, "2")
        XCTAssertEqual(viewController.snippets[1].text, "3")
    }

}

class MockViewController: ViewController {
    
    //HACK: Sync loading logic for tests
    override func reloadSnippets(_ dataAcc: DataAccessProtocol) {
        loadActivityIndicator.startAnimating()
        tableView.backgroundView = loadActivityIndicator
        self.snippets = dataAcc.loadSnippets()
        // Update UI via runloop
        self.tableView.reloadData()
        self.toggleNoSnippetsLabel()
        
    }
}

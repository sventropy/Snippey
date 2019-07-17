//
//  KeyboardViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest
@testable import Snippey

class KeyboardViewControllerTests: XCTestCase {

    var viewController: MockKeyboardViewController?
    var dataAccess: MockDataAccess?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = MockKeyboardViewController()
        dataAccess = MockDataAccess()
        viewController!.dataAccess = dataAccess!
        viewController?.viewDidLoad()
        viewController?.viewWillAppear(true)
        viewController?.viewWillLayoutSubviews()
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

    func testKeyboardSwitcherNotShownOnIPhoneX() {
        viewController?.setNeedsInputModeSwitchKey(value: false)
        viewController?.viewWillAppear(true)
        viewController?.viewWillLayoutSubviews()
        if let barButtonItem = viewController?.keyboardSwitchBarButtonItem {
            let contains = viewController?.toolbar.items?.contains(barButtonItem)
            XCTAssertNotNil(contains)
            if let cont = contains {
                XCTAssertFalse(cont)
            }
        }
    }

    func testKeyboardSwitcherShownOnIPhonePreX() {
        viewController?.setNeedsInputModeSwitchKey(value: true)
        viewController?.viewWillAppear(true)
        viewController?.viewWillLayoutSubviews()
        if let barButtonItem = viewController?.keyboardSwitchBarButtonItem {
            let contains = viewController?.toolbar.items?.contains(barButtonItem)
            XCTAssertNotNil(contains)
            if let cont = contains {
                XCTAssertTrue(cont)
            }
        }
    }

    func testKeyboardShowsSnippetText() {
        while(viewController?.snippets.count == 0) {
            sleep(1)
        }
        let cellText = viewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text
        XCTAssertNotNil(cellText)
        let snippetText = viewController?.snippets[0].text
        XCTAssertNotNil(snippetText)

        if let cellText2 = cellText {
            if let snippetText2 = snippetText {
                XCTAssertEqual(cellText2, snippetText2)
            }
        }
    }

    func testOnTapInsertTextCalled() {
        viewController!.tableView(viewController!.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        guard let mockTextDocumentProxy = viewController!.textDocumentProxy as? MockTextDocumentProxy else {
            XCTFail("Mock setup corrupt")
            return
        }
        XCTAssertTrue(mockTextDocumentProxy.wasInsertTextCalled)
    }

    func testOnBackspaceDeleteBackwardCalled() {
        viewController!.backspaceTouchUp(self)
        guard let mockTextDocumentProxy = viewController!.textDocumentProxy as? MockTextDocumentProxy else {
            XCTFail("Mock setup corrupt")
            return
        }
        XCTAssertTrue(mockTextDocumentProxy.wasDeletebackwardCalled)
    }

}

class MockKeyboardViewController: KeyboardViewController {

    private var _needsInputModeSwitchKey: Bool = false
    private var _textDocumentProxy: MockTextDocumentProxy = MockTextDocumentProxy()
    override var needsInputModeSwitchKey: Bool { return _needsInputModeSwitchKey }
    override var textDocumentProxy: UITextDocumentProxy { return _textDocumentProxy }
    fileprivate var snippetsLoaded = false

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    func setNeedsInputModeSwitchKey(value: Bool) {
        _needsInputModeSwitchKey = value
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.snippets = self.dataAccess.loadSnippets()
        self.tableView.backgroundView = self.backgroundLabel
        self.tableView.backgroundView!.isHidden = self.snippets.count > 0
        self.loadActivityIndicator!.stopAnimating()
        self.tableView.reloadData()
    }
    
}

class MockTextDocumentProxy: NSObject, UITextDocumentProxy {

    var documentContextBeforeInput: String?

    var documentContextAfterInput: String?

    var selectedText: String?

    var documentInputMode: UITextInputMode?

    var documentIdentifier: UUID = UUID.init()

    override init() {
        super.init()
    }

    var hasText: Bool = false
    var wasInsertTextCalled: Bool = false
    var wasDeletebackwardCalled: Bool = false

    func insertText(_ text: String) {
        wasInsertTextCalled = true
    }

    func deleteBackward() {
        wasDeletebackwardCalled = true
    }

    func adjustTextPosition(byCharacterOffset offset: Int) {

    }
    
    var keyboardAppearance: UIKeyboardAppearance = .default

}

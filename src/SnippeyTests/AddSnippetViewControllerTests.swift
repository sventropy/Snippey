//
//  AddSnippetViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest
@testable import Snippey

class AddSnippetViewControllerTests: XCTestCase {

    var addSnippetViewController: AddSnippetViewController?
    var addSnippetViewControllerDelegate: MockAddSnippetViewControllerDelegate?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addSnippetViewController = AddSnippetViewController()
        addSnippetViewControllerDelegate = MockAddSnippetViewControllerDelegate()
        addSnippetViewController?.delegate = addSnippetViewControllerDelegate
        addSnippetViewController?.viewDidLoad()
        addSnippetViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoTextSaveDisabled() {
        //textView is empty by default
        XCTAssertFalse(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }

    func testTextLargerThresholdSaveDisabled() {
        // String is 205 characters long
        let shouldChange = addSnippetViewController!.textView(
            addSnippetViewController!.textView!, shouldChangeTextIn: NSRange(location: 0, length: 4),
            replacementText: """
                                testtesttesttesttesttesttesttesttesttesttesttesttesttesttest
                                testtesttesttesttesttesttesttesttesttesttesttesttesttesttest
                                testtesttesttesttesttesttesttesttesttesttesttesttesttesttest
                                testtesttesttesttesttest
                                """)
        XCTAssertFalse(shouldChange)
        XCTAssertFalse(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }

    func testTextLargerZeroAndSmallerThresholdSaveEnabled() {
        let shouldChange = addSnippetViewController!.textView(addSnippetViewController!.textView!,
                                                              shouldChangeTextIn: NSRange(location: 0, length: 4),
                                                              replacementText: "test")
        XCTAssertFalse(shouldChange) // update of text is handled manually in delegate function
        XCTAssertTrue(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }

    func testTextEmptyPlaceholderDisplayed() {
        XCTAssertEqual(addSnippetViewController!.textView!.text, "add-new-snippet-alert-text-placeholder".localized)
    }

    func testEnterNewlineCharacterRejected() {
        let shouldChange = addSnippetViewController!.textView(addSnippetViewController!.textView!,
                                                              shouldChangeTextIn: NSRange(location: 0, length: 4),
                                                              replacementText: "\n")
        XCTAssertFalse(shouldChange) // update of text is handled manually in delegate function
        XCTAssertEqual(addSnippetViewController!.textView!.text,
                       "add-new-snippet-alert-text-placeholder".localized) // Still the placeholder
    }
    
    func testSaveCallsDelegate() {
        addSnippetViewController?.addSnippet()
        XCTAssert(addSnippetViewControllerDelegate!.didAddSnippet)
    }
    
    func testSaveCallsDelegateWithText() {
        addSnippetViewController?.textView?.text = "TestText"
        addSnippetViewController?.addSnippet()
        XCTAssertEqual(addSnippetViewControllerDelegate!.text, addSnippetViewController!.textView!.text)
    }
}

class MockAddSnippetViewControllerDelegate : AddSnippetViewControllerDelegate {
    
    var didAddSnippet: Bool = false
    var text: String = ""
    
    func didAddNewSnippet(snippetText: String) {
        didAddSnippet = true
        text = snippetText
    }
    
}

//
//  AddSnippetViewControllerTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 06.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest

class AddSnippetViewControllerTests: XCTestCase {

    var addSnippetViewController : AddSnippetViewController?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addSnippetViewController = AddSnippetViewController()
        addSnippetViewController?.viewDidLoad()
        addSnippetViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //TODO
    // test save, no text
    func testNoTextSaveDisabled() {
        //textView is empty by default
        XCTAssertFalse(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func testTextLargerThresholdSaveDisabled() {
        // String is 205 characters long
        let shouldChange = addSnippetViewController!.textView(addSnippetViewController!.textView!, shouldChangeTextIn: NSRange(location: 0, length: 4), replacementText: "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest")
        XCTAssertFalse(shouldChange)
        XCTAssertFalse(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func testTextLargerZeroAndSmallerThresholdSaveEnabled() {
        let shouldChange = addSnippetViewController!.textView(addSnippetViewController!.textView!, shouldChangeTextIn: NSRange(location: 0, length: 4), replacementText: "test")
        XCTAssertFalse(shouldChange) // update of text is handled manually in delegate function
        XCTAssertTrue(addSnippetViewController!.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func testTextEmptyPlaceholderDisplayed() {
        XCTAssertEqual(addSnippetViewController!.textView!.text, "add-new-snippet-alert-text-placeholder".localized)
    }
    
    func testEnterNewlineCharacterRejected(){
        let shouldChange = addSnippetViewController!.textView(addSnippetViewController!.textView!, shouldChangeTextIn: NSRange(location: 0, length: 4), replacementText: "\n")
        XCTAssertFalse(shouldChange) // update of text is handled manually in delegate function
        XCTAssertEqual(addSnippetViewController!.textView!.text, "add-new-snippet-alert-text-placeholder".localized) // Still the placeholder
    }
}

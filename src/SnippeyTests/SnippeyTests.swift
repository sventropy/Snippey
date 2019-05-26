//
//  SnippeyTests.swift
//  SnippeyTests
//
//  Created by Hennessen, Sven on 26.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import XCTest
import UIKit

class SnippeyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_util_findFirstSubviewOfTypeRecursive_findSimpleSubview_Success() {
        let button = UIButton()
        let view = UIView()
        view.addSubview(button)
        let viewFound = Util.findFirstSubviewOfTypeRecursive(view: view, targetType: UIButton.self)
        XCTAssertEqual(button, viewFound)
    }
    
    func test_util_findFirstSubviewOfTypeRecursive_findInMultipleSubviews_Success() {
        let button = UIButton()
        let label = UILabel()
        let textField = UITextField()
        let view = UIView()
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(textField)
        let viewFound = Util.findFirstSubviewOfTypeRecursive(view: view, targetType: UIButton.self)
        XCTAssertEqual(button, viewFound)
    }
    
    func test_util_findFirstSubviewOfTypeRecursive_findTargetIsParameter_Success() {
        let button = UIButton()
        let viewFound = Util.findFirstSubviewOfTypeRecursive(view: button, targetType: UIButton.self)
        XCTAssertEqual(button, viewFound)
    }

    func test_util_findFirstSubviewOfTypeRecursive_findNoMatch_Fail() {
        let label = UILabel()
        let textField = UITextField()
        let view = UIView()
        view.addSubview(label)
        view.addSubview(textField)
        let viewFound = Util.findFirstSubviewOfTypeRecursive(view: view, targetType: UIButton.self)
        XCTAssertNil(viewFound)
    }
}

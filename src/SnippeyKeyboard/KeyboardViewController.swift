//
//  KeyboardViewController.swift
//  SnippeyKeyboard
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit
import Foundation

/// Keyboard extension view controller implementation providing the list of snippets as a keyboard
class KeyboardViewController: UIInputViewController {

    // MARK: - Properties

    var snippets: [Snippet] = []
    // Data access is exposed as property to allow testing the implementation of this class
    var dataAccess: DataAccessProtocol = DataAccess()
    var longpressDeleteTimer: Timer?

    var tableView: UITableView = UITableView()
    var keyboardSwitchBarButtonItem = UIBarButtonItem()
    var backspaceBarButtonItem = UIBarButtonItem()
    var toolbar: UIToolbar = UIToolbar()
    var stackView: UIView = UIView()
    var backgroundLabel: UILabel?
    var keyboardSwitchButton = UIButton()
    var backspaceButton = UIButton()
    
    private var showDarkKeyboard: Bool = false

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleController.applyStyle()

        // Create controls
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        let backgroundLabelFrame = CGRect(x: 0,
                                          y: 0,
                                          width: tableView.bounds.size.width,
                                          height: tableView.bounds.size.height)
        backgroundLabel = UILabel(frame: backgroundLabelFrame)
        backgroundLabel!.text = "list-no-snippets-label".localized
        backgroundLabel!.textAlignment = .center
        tableView.backgroundView = backgroundLabel

        keyboardSwitchButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardSwitchTouchUp)))
        keyboardSwitchButton.setImage(StyleController.loadIconResized(assetName: "icons8-globe-50"), for: .normal)
        keyboardSwitchButton.setImage(UIImage(named: "icons8-globe-filled-50"), for: .highlighted)
        keyboardSwitchButton.imageEdgeInsets = UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: Constants.margin, right: Constants.margin)
        keyboardSwitchBarButtonItem.customView = keyboardSwitchButton
        
        backspaceButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backspaceTouchUp)))
        // Long press does only work with custom views in a UIBarButtonItem
        backspaceButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(backspaceLongPress)))
        backspaceButton.setImage(UIImage(named: "icons8-clear-symbol-50"), for: .normal)
        backspaceButton.setImage(UIImage(named: "icons8-clear-symbol-filled-50"), for: .highlighted)
        backspaceButton.imageEdgeInsets = UIEdgeInsets(top: Constants.margin, left: Constants.margin, bottom: Constants.margin, right: Constants.margin)
        backspaceBarButtonItem.customView = backspaceButton
        
        stackView.addSubview(tableView)
        stackView.addSubview(toolbar)

        inputView?.addSubview(stackView)
        
        // Autolayout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: Constants.toolbarHeight).isActive = true
        backspaceButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backspaceButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        keyboardSwitchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        keyboardSwitchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.description + ": viewWillAppear")

        // Clear everything and reload
        snippets.removeAll()
        snippets = dataAccess.loadSnippets()
        tableView.reloadData()

        tableView.backgroundView?.isHidden = snippets.count > 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Compute correct toolbar items, must be done in viewWillAppear
        var toolbarItems =
            [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), backspaceBarButtonItem]
        print("needsInputModeSwitchKey=\(needsInputModeSwitchKey)")
        if needsInputModeSwitchKey {
            toolbarItems.insert(keyboardSwitchBarButtonItem, at: 0)
        }
        toolbar.setItems(toolbarItems, animated: true)
        
        let keyboardHeight = needsInputModeSwitchKey
            ? Constants.keyboardHeightIPhone : Constants.keyboardHeightIPhoneX
        inputView?.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
        
        showDarkKeyboard = textDocumentProxy.keyboardAppearance == .dark
        backgroundLabel!.textColor = showDarkKeyboard ? Constants.lightColor : Constants.textColor
        tableView.backgroundColor = showDarkKeyboard ? UIColor.darkGray : Constants.mediumColor
        toolbar.tintColor = showDarkKeyboard ? Constants.lightColor : Constants.textColor
        toolbar.barTintColor = showDarkKeyboard ? UIColor.darkGray : Constants.mediumColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    // MARK: - Keyboard Extension

    @objc func keyboardSwitchTouchUp(_ sender: Any) {
        print("Switching keyboard")
        advanceToNextInputMode()
    }

    @objc func backspaceTouchUp(_ sender: Any) {
        print("Backspace pressed")
        textDocumentProxy.deleteBackward()
    }

    @objc func backspaceLongPress(gesture: UILongPressGestureRecognizer) {
        print("Backspace long pressed")

        if gesture.state == .began {
            longpressDeleteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                self.textDocumentProxy.deleteBackward()
            })
        } else if gesture.state == .ended || gesture.state == .cancelled {
            longpressDeleteTimer?.invalidate()
            longpressDeleteTimer = nil
        }
    }
}

// MARK: - UITableView

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)

        // Configure the cell...
        let snippet = snippets[indexPath.row]
        cell.textLabel?.text = snippet.text
        StyleController.applyCellStyle(tableViewCell: cell, isDark: textDocumentProxy.keyboardAppearance == .dark)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snippet = snippets[indexPath.row]
        textDocumentProxy.insertText(snippet.text)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

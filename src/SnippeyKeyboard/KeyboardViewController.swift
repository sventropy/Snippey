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
    var keyboardSwitchButton: UIBarButtonItem = UIBarButtonItem()
    var backspaceButton: UIBarButtonItem = UIBarButtonItem()
    var toolbar: UIToolbar = UIToolbar()
    var stackView: UIView = UIView()
    var backgroundLabel: UILabel?
    var backspaceLabel = UILabel()
    
    private var showDarkKeyboard: Bool = false

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StyleController.applyStyle()

        // Create controls
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        // TODO redunant to app, consolidate
        let backgroundLabelFrame = CGRect(x: 0,
                                          y: 0,
                                          width: tableView.bounds.size.width,
                                          height: tableView.bounds.size.height)
        backgroundLabel = UILabel(frame: backgroundLabelFrame)
        backgroundLabel!.text = "list-no-snippets-label".localized
        backgroundLabel!.textAlignment = .center
        tableView.backgroundView = backgroundLabel

        keyboardSwitchButton.title = "⌨︎"
        keyboardSwitchButton.action = #selector(keyboardSwitchTouchUp)

        backspaceLabel.text = "⌫"
        backspaceLabel.isUserInteractionEnabled = true
        backspaceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backspaceTouchUp)))
        backspaceLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(backspaceLongPress)))
        backspaceButton.customView = backspaceLabel

        stackView.addSubview(tableView)
        stackView.addSubview(toolbar)

        inputView?.addSubview(stackView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Clear everything and reload
        snippets.removeAll()
        snippets = dataAccess.loadSnippets()
        tableView.reloadData()

        // Compute correct toolbar items, must be done in viewWillAppear
        var toolbarItems =
            [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), backspaceButton]
        if needsInputModeSwitchKey {
            toolbarItems.insert(keyboardSwitchButton, at: 0)
        }
        toolbar.setItems(toolbarItems, animated: true)

        // Autolayout
        // HACK: Use inputmodeswitch indicator to determine iPhoneX(s/r) vs others
        let showKeyboardSwitcher = needsInputModeSwitchKey
                                ? Constants.keyboardHeightIPhone : Constants.keyboardHeightIPhoneX
        inputView?.heightAnchor.constraint(equalToConstant: showKeyboardSwitcher).isActive = true
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

        tableView.backgroundView?.isHidden = snippets.count > 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        showDarkKeyboard = textDocumentProxy.keyboardAppearance == .dark
        backgroundLabel!.textColor = showDarkKeyboard ? Constants.lightColor : Constants.textColor
        tableView.backgroundColor = showDarkKeyboard ? UIColor.darkGray : Constants.mediumColor
        toolbar.tintColor = showDarkKeyboard ? Constants.lightColor : Constants.textColor
        backspaceLabel.textColor = showDarkKeyboard ? Constants.lightColor : Constants.textColor

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

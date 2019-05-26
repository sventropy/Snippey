//
//  KeyboardViewController.swift
//  SnippeyKeyboard
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit
import Foundation

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    
    var snippets: [Snippet] = []
    
    var tableView: UITableView = UITableView()
    var keyboardSwitchButton: UIBarButtonItem = UIBarButtonItem()
    var backspaceButton: UIBarButtonItem = UIBarButtonItem()
    var toolbar: UIToolbar = UIToolbar()
    var stackView: UIView = UIView()
    
    // MARK: - UIView Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        // Create UI elements
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        keyboardSwitchButton.title = "⌨︎"
        keyboardSwitchButton.action = #selector(keyboardSwitchTouchUp)
        backspaceButton.title = "⌫"
        backspaceButton.action = #selector(backspaceTouchUp)
        stackView.addSubview(tableView)
        stackView.addSubview(toolbar)
        inputView?.addSubview(stackView)
        
        // Styling
        tableView.backgroundColor = Constants.keyboardBackgroundColor
        toolbar.backgroundColor = Constants.keyboardBackgroundColor
        toolbar.tintColor = Constants.textColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        // Clear everything and reload
        snippets.removeAll()
        snippets = Data.sharedInstance.loadSnippets()
        tableView.reloadData()
        
        // Compute correct toolbar items, must be done in viewWillAppear
        var toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), backspaceButton]
        if(needsInputModeSwitchKey) {
            toolbarItems.insert(keyboardSwitchButton, at: 0)
        }
        toolbar.setItems(toolbarItems, animated: true)
        
        // Autolayout
        inputView?.heightAnchor.constraint(equalToConstant: needsInputModeSwitchKey ? 258.0 : 333.0).isActive = true // HACK: Use inputmodeswitch indicator to determine iPhoneX(s/r) vs others
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
        toolbar.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
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
}

// MARK: - UITableView

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)
        
        // Configure the cell...
        let emoticon = snippets[indexPath.row];
        cell.textLabel?.text = emoticon.title
        cell.detailTextLabel?.text = emoticon.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emoticon = snippets[indexPath.row];
        self.textDocumentProxy.insertText(emoticon.text)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

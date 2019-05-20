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
    let keyboardSwitchButton: UIBarButtonItem = UIBarButtonItem()
    let backspaceButton: UIBarButtonItem = UIBarButtonItem()
    let toolbar: UIToolbar = UIToolbar()
    
    // MARK: - UIView Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        // Create UI elements
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        keyboardSwitchButton.title = "⌨︎"
        keyboardSwitchButton.action = #selector(keyboardSwitchTouchUp)
        backspaceButton.title = "⌫"
        backspaceButton.action = #selector(backspaceTouchUp)
        toolbar.setItems([keyboardSwitchButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), backspaceButton], animated: true)
        let stackView = UIView()
        stackView.addSubview(tableView)
        stackView.addSubview(toolbar)
        self.view.addSubview(stackView)
        
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
        toolbar.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 258.0).isActive = true
        
        // Styling
        tableView.backgroundColor = Constants.keyboardBackgroundColor
        toolbar.backgroundColor = Constants.keyboardBackgroundColor
        toolbar.tintColor = Constants.textColor
        
//        self.printViewsIntrinsicSizeRecursive(views: view.subviews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        refreshSnippets()
        tableView.reloadData()
        
//        self.printViewsIntrinsicSizeRecursive(views: view.subviews)
    }
    
    // MARK: - Keyboard Extension
    
    @objc func keyboardSwitchTouchUp(_ sender: Any) {
        self.advanceToNextInputMode()
    }
    
    @objc func backspaceTouchUp(_ sender: Any) {
        self.textDocumentProxy.deleteBackward()
    }
    
    // MARK: - Data Access
    
    fileprivate func refreshSnippets() {
        
        // Clear everything
        self.snippets.removeAll()
        self.snippets = Data.sharedInstance.loadSnippets()
    }
    
    func printViewsIntrinsicSizeRecursive(views:[UIView]!) {
        
        if(views.count == 0){ return }
        
        for v in views {
            print("View:", String(describing: v), "|w:",v.intrinsicContentSize.width, "|h:",v.intrinsicContentSize.height)
            self.printViewsIntrinsicSizeRecursive(views: v.subviews)
        }
    }
}

// MARK: - UITableView

extension KeyboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.snippets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)
        
        // Configure the cell...
        let emoticon = self.snippets[indexPath.row];
        cell.textLabel?.text = emoticon.title
        cell.detailTextLabel?.text = emoticon.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emoticon = self.snippets[indexPath.row];
        self.textDocumentProxy.insertText(emoticon.text)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

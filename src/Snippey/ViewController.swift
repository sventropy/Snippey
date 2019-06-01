//
//  ViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Properties
    
    var snippets : [Snippet] = []
    
    var addBarButtonItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnippet))
    }
    
    // UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add title
        self.navigationItem.title = "list-title".localized
        
        // Setup data
        Data.sharedInstance.initializeDefaultSnippets()
        
        // Setup tableview
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.backgroundColor = Constants.keyboardBackgroundColor
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        snippets = Data.sharedInstance.loadSnippets()
        tableView.reloadData()
        
        tableView.frame = tableView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add button
        toggleAddButtonVisible()
        
        // Edit button
        toggleEditButton()
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)
        
        // Configure the cell...
        let emoticon = snippets[indexPath.row]
        cell.textLabel?.text = emoticon.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Only delete handled here
        if editingStyle == .delete {
            // Delete the row from the data source
            snippets.remove(at: indexPath.row)
            Data.sharedInstance.storeSnippets(snippets: snippets)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update datasource
        let snippet = snippets[sourceIndexPath.row]
        snippets.remove(at: sourceIndexPath.row)
        snippets.insert(snippet, at: destinationIndexPath.row)
        
        // Update UI
        Data.sharedInstance.storeSnippets(snippets: snippets)
    }
    
    // MARK: Actions
    
    @objc func toggleEditMode() {
        
        // toggle editing
        tableView.setEditing(!tableView.isEditing, animated: true)
        toggleEditButton()
        toggleAddButtonVisible()
    }
    
    func toggleEditButton() {
        
        // toggle bar button item
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit, target: self, action: #selector(toggleEditMode))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func toggleAddButtonVisible() {
        
        // hide add bar button item in tableview edit mode
        if(tableView.isEditing) {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = addBarButtonItem
        }
    }
    
    @objc func addSnippet() {

        // Build alert to allow adding new snippet
        let alertController = AddSnippetAlertController(title: "add-new-snippet-alert-title".localized, message: nil, preferredStyle: .alert)
        alertController.delegate = self
        
        // Show
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController : AddSnippetAlertControllerDelegate {
    
    func didAddNewSnippet(snippetText: String) {
        
        self.snippets.append(Snippet(text: snippetText))
        // Update model
        Data.sharedInstance.storeSnippets(snippets: self.snippets)
        // Reload ui
        self.tableView.reloadData()
    }
}



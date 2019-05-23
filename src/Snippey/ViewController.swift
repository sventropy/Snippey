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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup data
        Data.sharedInstance.initializeDefaultSnippets()
        
        // Setup tableview
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        snippets = Data.sharedInstance.loadSnippets()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add button
        
        // While editing add 'add' button
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnippet))
        navigationItem.leftBarButtonItem = addBarButtonItem
        
        // Edit button
        toggleEditButton()
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snippetCell", for: indexPath)
        
        // Configure the cell...
        let emoticon = snippets[indexPath.row];
        cell.textLabel?.text = emoticon.title
        cell.detailTextLabel?.text = emoticon.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }
    
    // MARK: Actions
    @objc func toggleEditMode() {
        
        // toggle editing
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        toggleEditButton()
    }
    
    func toggleEditButton() {
        
        // toggle bar button item
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit, target: self, action: #selector(toggleEditMode))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func ensureNotEditing() {
        // Ensure not enditing
        if(tableView.isEditing){
            tableView.setEditing(false, animated: true)
        }
    }
    
    
    @objc func addSnippet() {
        
        ensureNotEditing()
        
        let alertController = UIAlertController(title: "Add Snippet", message: nil, preferredStyle: .alert)
        
        // TextFields
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Title"
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInAlert), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Snippet"
            textField.addTarget(alertController, action: #selector(alertController.textDidChangeInAlert), for: .editingChanged)
        }
        
        // Actions
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            // Ensure both textfields filled
            guard let snippetTitle = alertController.textFields?[0].text,
                let snippetText = alertController.textFields?[1].text
                else { return }
            
            self.snippets.append(Snippet(title: snippetTitle, text: snippetText))
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        confirmAction.isEnabled = false
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Show
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIAlertController {
    
    @objc func textDidChangeInAlert() {
        if let snippetTitle = textFields?[0].text,
            let snippetText = textFields?[1].text,
            let action = actions.first {
            action.isEnabled = !snippetTitle.isEmpty && !snippetText.isEmpty
        }
    }
}



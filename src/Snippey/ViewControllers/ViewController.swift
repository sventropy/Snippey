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
    var dataAccess : DataAccess?
    var noSnippetsLabel : UILabel?

    // UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add title
        self.navigationItem.title = "list-title".localized
        
        // Setup tableview
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.reorder.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        snippets = dataAccess?.loadSnippets() ?? [Snippet]()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnippet))
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Handle reordering
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
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
            dataAccess?.storeSnippets(snippets: snippets)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    @objc func addSnippet() {

        // Build alert to allow adding new snippet
        let addSnippetViewController = AddSnippetViewController()
        addSnippetViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addSnippetViewController)

        // Show
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension ViewController : AddSnippetViewControllerDelegate {
    
    func didAddNewSnippet(snippetText: String) {
        
        self.snippets.append(Snippet(text: snippetText))
        // Update model
        dataAccess?.storeSnippets(snippets: self.snippets)
        // Reload ui
        self.tableView.reloadData()
    }
}

extension ViewController : TableViewReorderDelegate {
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data source
        let snippet = snippets[sourceIndexPath.row]
        snippets.remove(at: sourceIndexPath.row)
        snippets.insert(snippet, at: destinationIndexPath.row)
        
        // Update UI
        dataAccess?.storeSnippets(snippets: snippets)
    }
}



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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        snippets = Data.sharedInstance.loadSnippets()
        tableView.reloadData()
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
        // Only delete handled here
        if editingStyle == .delete {
            // Delete the row from the data source
            snippets.remove(at: indexPath.row)
            Data.sharedInstance.storeSnippets(snippets: snippets)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        let alertController = buildAddAlertController()
        
        // Show
        present(alertController, animated: true, completion: nil)
    }
    
    
    func buildAddAlertController() -> UIAlertController {
        
        // Use dialog as a basis
        let alertController = UIAlertController(title: "add-new-snippet-alert-title".localized, message: nil, preferredStyle: .alert)

        // One textview to enter snippet

//            textField.placeholder = "add-new-snippet-alert-text-placeholder".localized
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.size.width - Constants.viewMargin * 2, height: 120))
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets.init(top: Constants.textAreaTopBottomInset, left: Constants.textAreaSideInset, bottom: Constants.textAreaTopBottomInset, right: Constants.textAreaSideInset)
        alertController.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 52).isActive = true
        textView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        textView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 224).isActive = true

        // Actions
        let confirmAction = UIAlertAction(title: "add-new-snippet-alert-add-button-label".localized, style: .default) { (_) in
            // Ensure textView is filled
            guard let snippetText = Util.findFirstSubviewOfTypeRecursive(view: alertController.view, targetType: UITextView.self)?.text
                else { return }

            self.snippets.append(Snippet(text: snippetText))
            // Update model
            Data.sharedInstance.storeSnippets(snippets: self.snippets)
            // Reload ui
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "add-new-snippet-alert-cancel-button-label".localized, style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: OperationQueue.main) { (notification) in
            confirmAction.isEnabled = !textView.text.isEmpty
        }

        // by default disable, enable when both fields valid
        confirmAction.isEnabled = false
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
}

//extension UIAlertController {
//
//    @objc func textDidChangeInAlert() {
//        if let snippetTitle = textFields?[0].text,
//            let snippetText = textFields?[1].text,
//            let action = actions.first {
//            action.isEnabled = !snippetTitle.isEmpty && !snippetText.isEmpty
//        }
//    }
//}



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
}



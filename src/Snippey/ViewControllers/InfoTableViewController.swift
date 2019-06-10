//
//  InfoTableTableViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 10.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    var dataAccess : DataAccess?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: Constants.infoCellReuseIdentifier )
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.infoHeaderViewReuseIdentifier)

        navigationItem.title = "info-title".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "info-back-button-title".localized, style: .done, target: self, action: #selector(dismissInfo))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Three static sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Static amount of rows per section
        var rows = 0
        switch section {
        case 0:
            rows = 2
        case 1:
            rows = 1
        case 2:
            rows = 1
        default:
            assertionFailure("tableview misconfigured!")
        }
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellReuseIdentifier, for: indexPath)

        // Configure the static cells
        switch indexPath.section {
        case 0:
            // App Info
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "info-link-snippey-appstore".localized
            case 1:
                cell.textLabel?.text = "info-link-sventropy-github".localized
            default:
                assertionFailure("Tableview misconfigured!")
            }
        case 1:
            // Open source dependencies
            cell.textLabel?.text = "info-link-deps-swiftreorder".localized
        case 2:
            // Reset button
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = "info-button-reset".localized
        default:
            assertionFailure("tableview misconfigured!")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView(reuseIdentifier: Constants.infoHeaderViewReuseIdentifier)
        switch section {
            case 0:
            header.textLabel?.text = "info-section-header-links".localized
            case 1:
            header.textLabel?.text = "info-section-header-deps".localized
            case 2:
            header.textLabel?.text = "info-section-header-reset".localized
            default:
            assertionFailure("tableview misconfigured!")
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // App Info
            switch indexPath.row {
            case 0:
                openUrl(urlString: "https://blablabla.blabla.me")
            case 1:
                openUrl(urlString: "https://github.com/sventropy")
            default:
                assertionFailure("Tableview misconfigured!")
            }
        case 1:
            // Open source dependencies
            openUrl(urlString: "https://github.com/adamshin/SwiftReorder")
        case 2:
            // Reset button
            let alertController = UIAlertController(title: "info-reset-alert-title".localized, message: "info-reset-alert-message".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "info-reset-alert-delete-button-title".localized, style: .destructive, handler: { (action) in
                self.dataAccess?.resetSnippets()
            }))
            alertController.addAction(UIAlertAction(title: "add-new-snippet-alert-cancel-button-label".localized, style: .cancel, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
            
        default:
            assertionFailure("tableview misconfigured!")
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func dismissInfo() {
        dismiss(animated: true, completion: nil)
    }
    
    private func openUrl(urlString: String) {
        guard let validUrl = URL(string: urlString) else { return }
        UIApplication.shared.open(validUrl, options: [:], completionHandler: nil)
    }
 
}


//
//  ViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController {

    // MARK: - Properties

    var snippets: [Snippet] = []
    var dataAccess: DataAccessProtocol?

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add title
        self.navigationItem.title = "list-title".localized

        // Setup tableview
        tableView.register(SnippetTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.reorder.delegate = self
        tableView.allowsSelection = false
        let backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        backgroundLabel.text = "list-no-snippets-label".localized
        backgroundLabel.textColor = Constants.textColor // HACK: Does not work via UIAppearance
        tableView.backgroundView = backgroundLabel
        tableView.accessibilityLabel = "access-snippet-list-label".localized
        
        setNeedsStatusBarAppearanceUpdate()
        
        // Check when app enters foreground after being in background to show/hide table header label properly
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        snippets = dataAccess?.loadSnippets() ?? [Snippet]()
        tableView.reloadData()
        toggleNoSnippetsLabel()

        // In case the keyboard is not configured in the Settings app, remind the user to do so
        if !isKeyboardExtensionEnabled() {
            tableView.tableHeaderView = createTableHeaderView()
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !isKeyboardExtensionEnabled() {
            // Fix header view frame, in case it is shown
            tableView.updateHeaderViewFrame()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isKeyboardExtensionEnabled() {
            // Fix header view frame, in case it is shown
            tableView.tableHeaderView?.frame = tableView.tableHeaderView!.frame.inset(by:
                UIEdgeInsets(top: 0, left: Constants.margin, bottom: 0, right: Constants.margin))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnippet))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "info-title".localized, style: .plain, target: self, action: #selector(showInfo))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - UITableViewController

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snippets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Handle reordering, required by SwiftReorder
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

            // Update background label in table view
            toggleNoSnippetsLabel()
        }
     }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Actions

    @objc func addSnippet() {

        // Build alert to allow adding new snippet
        let addSnippetViewController = AddSnippetViewController()
        addSnippetViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addSnippetViewController)

        // Show
        present(navigationController, animated: true, completion: nil)
    }

    @objc func showInfo() {
        let infoViewController = InfoTableViewController()
        infoViewController.dataAccess = dataAccess
        let navigationController = UINavigationController(rootViewController: infoViewController)
        // Show
        present(navigationController, animated: true, completion: nil)
    }

    @objc func openAppSettings() {
        Util.openUrl(urlString: UIApplication.openSettingsURLString)
    }
    
    @objc func applicationWillEnterForeGround() {
        // In case the keyboard is not configured in the Settings app, remind the user to do so
        if !isKeyboardExtensionEnabled() {
            tableView.tableHeaderView = createTableHeaderView()
        } else {
            tableView.tableHeaderView = nil
        }
    }

    // MARK: - Private

    private func toggleNoSnippetsLabel() {
        tableView.backgroundView?.isHidden = snippets.count > 0
    }

    private func isKeyboardExtensionEnabled() -> Bool {
        if let keyboards = UserDefaults.standard.object(forKey: Constants.appleKeyboardDefaultsKey) as? [String] {
            return keyboards.contains(Constants.snippeyKeyboardBundleId)
        }
        return true
    }

    private func createTableHeaderView() -> UILabel {
        let headerLabel = UILabel()
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.numberOfLines = 0
        headerLabel.text = "list-header-label-text".localized
        headerLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        headerLabel.textColor = Constants.darkColor
        headerLabel.textAlignment = .left
        headerLabel.isUserInteractionEnabled = true
        headerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAppSettings)))
        return headerLabel
    }
}

// MARK: - Implementation of add delegate

extension ViewController: AddSnippetViewControllerDelegate {

    func didAddNewSnippet(snippetText: String) {

        snippets.append(Snippet(text: snippetText))
        // Update model
        dataAccess?.storeSnippets(snippets: self.snippets)
        // Reload ui
        tableView.reloadData()
    }
}

// MARK: - Implementation of reorder delegate

extension ViewController: TableViewReorderDelegate {

    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data source
        let snippet = snippets[sourceIndexPath.row]
        snippets.remove(at: sourceIndexPath.row)
        snippets.insert(snippet, at: destinationIndexPath.row)

        // Update UI
        dataAccess?.storeSnippets(snippets: snippets)
    }
}

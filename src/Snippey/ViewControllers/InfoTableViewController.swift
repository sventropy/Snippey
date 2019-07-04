//
//  InfoTableTableViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 10.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// View Controller presenting background information on the app and a reset feature to wipe all data
class InfoTableViewController: UITableViewController {

    // MARK: - Properties

    var dataAccess: DataAccessProtocol?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: Constants.infoCellReuseIdentifier )
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: Constants.infoHeaderViewReuseIdentifier)

        navigationItem.title = "info-title".localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "info-back-button-title".localized,
                                                           style: .plain, target: self,
                                                           action: #selector(dismissInfo))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            rows = 2
        default:
            assertionFailure(Constants.switchAssertionFailureMessage)
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
                cell.textLabel?.text = "info-link-snippey-privacy-policy".localized
            case 1:
                cell.textLabel?.text = "info-link-sventropy-github".localized
            default:
                assertionFailure(Constants.switchAssertionFailureMessage)
            }
        case 1:
            // Open source dependencies
            cell.textLabel?.text = "info-link-deps-swiftreorder".localized
        case 2:
            switch indexPath.row {
            case 0:
                // Restart tutorial button
                cell.textLabel?.text = "info-restart-tutorial-button".localized
            case 1:
                // Reset button
                cell.textLabel?.textColor = .red
                cell.textLabel?.text = "info-button-reset".localized
            default:
                assertionFailure(Constants.switchAssertionFailureMessage)
            }
        default:
            assertionFailure(Constants.switchAssertionFailureMessage)
        }

        cell.accessibilityTraits.insert(.button) // in conjunction with static text

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
            assertionFailure(Constants.switchAssertionFailureMessage)
        }
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // App Info
            switch indexPath.row {
            case 0:
                Util.openUrl(urlString: Constants.urlSnippeyPrivacyPolicy)
            case 1:
                Util.openUrl(urlString: Constants.urlSnippeyDevGitHub)
            default:
                assertionFailure(Constants.switchAssertionFailureMessage)
            }
        case 1:
            // Open source dependencies
            Util.openUrl(urlString: Constants.urlSwiftReorderGitHub)
        case 2:
            
            switch indexPath.row {
            case 0:
                let tutorialPageViewController = TutorialPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                tutorialPageViewController.dataAccess = dataAccess
                UIWindow.animate(withDuration: 0.2) {
                    UIApplication.shared.keyWindow!.rootViewController = tutorialPageViewController
                }
                dismissInfo()
            case 1:
                showResetConfirmationAlert()
            default:
                assertionFailure(Constants.switchAssertionFailureMessage)
            }
        default:
            assertionFailure(Constants.switchAssertionFailureMessage)
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }

    // MARK: - Actions

    @objc func dismissInfo() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private

    fileprivate func showResetConfirmationAlert() {
        // Reset button
        let alertController = UIAlertController(title: "info-reset-alert-title".localized,
                                                message: "info-reset-alert-message".localized,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "info-reset-alert-delete-button-title".localized,
                                                style: .destructive, handler: { (_) in
                                                    self.dataAccess?.resetSnippets()
                                                    self.dismissInfo()
        }))
        alertController.addAction(UIAlertAction(title: "add-new-snippet-alert-cancel-button-label".localized,
                                                style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

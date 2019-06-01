//
//  AddSnippetViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 01.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class AddSnippetViewController: UIViewController {
    
    var delegate : AddSnippetViewControllerDelegate?
    var textView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Controls
        textView = UITextView()
        view.addSubview(textView!)
        
        // Autolayout
        textView?.translatesAutoresizingMaskIntoConstraints = false
        textView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView?.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        // Align text view with rest of alert
        view.backgroundColor = Constants.keyboardBackgroundColor
        textView?.backgroundColor = view.backgroundColor
        textView?.textColor = view.tintColor
        textView?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        // Navigation item
        title = "add-new-snippet-alert-title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addSnippet))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddSnippet))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Place cursor into single textview on display
        textView!.becomeFirstResponder()
    }
    
    @objc func addSnippet() {
        // Ensure textView is filled
        guard let snippetText = textView?.text
            else { return }
        
        // Notify delegate about update
        self.delegate?.didAddNewSnippet(snippetText: snippetText)
        
        // Finish up
        dismiss()
    }
    
    @objc func cancelAddSnippet() {
        dismiss()
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

protocol AddSnippetViewControllerDelegate {
    
    // Notify delegate about new snippet creation
    func didAddNewSnippet(snippetText: String)
}

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
        textView!.delegate = self
        
        // Autolayout
        textView!.translatesAutoresizingMaskIntoConstraints = false
        textView!.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.margin).isActive = true
        textView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin).isActive = true
        textView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.margin).isActive = true
        textView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.margin).isActive = true
        
        // Styling
        textView!.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        // Start with placeholder
        textView!.text = "add-new-snippet-alert-text-placeholder".localized
        textView!.textColor = Style.sharedInstance.placeholderColor
        // HACK: Explicitly set view background color to avoid messing up appearance of UIView
        view.backgroundColor = Style.sharedInstance.viewBackgroundColor
        
        // Navigation item
        title = "add-new-snippet-alert-title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addSnippet))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddSnippet))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Place cursor into single textview on display
        textView!.becomeFirstResponder()
        textView!.selectedTextRange = textView!.textRange(from: textView!.beginningOfDocument, to: textView!.beginningOfDocument)
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

extension AddSnippetViewController : UITextViewDelegate {
    
    // Based on solution #2 from https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "add-new-snippet-alert-text-placeholder".localized
            textView.textColor = Style.sharedInstance.placeholderColor
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == Style.sharedInstance.placeholderColor && !text.isEmpty {
            textView.textColor = Style.sharedInstance.textColor
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    // Make sure cursor is not placed elsewhere while showing placeholder
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == Style.sharedInstance.placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
}

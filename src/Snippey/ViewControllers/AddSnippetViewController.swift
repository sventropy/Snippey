//
//  AddSnippetViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 01.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

// UIViewController acting as entry form for new snippets in the app. Validates entry length against given constraints and saves new snippets on completion.
class AddSnippetViewController: UIViewController {
    
    // MAKR: - Properties
    
    var delegate : AddSnippetViewControllerDelegate?
    var textView: UITextView?
    var snippetLengthLabel: UILabel?
    
    // MAKR: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Controls
        createSnippetTextView()
        createCharacterCountLabel() // requires textview to exist
        
        // HACK: Explicitly set view background color to avoid messing up appearance of UIView
        view.backgroundColor = Constants.lightColor
        
        // Navigation item
        title = "add-new-snippet-alert-title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addSnippet))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddSnippet))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Place cursor into single textview on display
        textView!.becomeFirstResponder()
        // For imitation of placeholder behavior
        textView!.selectedTextRange = textView!.textRange(from: textView!.beginningOfDocument, to: textView!.beginningOfDocument)
    }
    
    override func viewDidLayoutSubviews() {

        // Add textView margin to the trailing end
        textView?.frame = textView!.frame.inset(by: UIEdgeInsets(top: CGFloat.zero, left: CGFloat.zero, bottom: CGFloat.zero, right: Constants.margin * 2))
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
    
    // MARK: - Private
    
    fileprivate func createCharacterCountLabel() {
        snippetLengthLabel = InsetLabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 32))
        snippetLengthLabel?.textAlignment = .right
        updateTextLengthLabel(text: String()) // Empty string
        textView!.inputAccessoryView = snippetLengthLabel!
    }
    
    fileprivate func createSnippetTextView() {
        textView = UITextView()
        view.addSubview(textView!)
        textView!.delegate = self
        textView?.keyboardType = .default
        
        // Autolayout
        textView!.translatesAutoresizingMaskIntoConstraints = false
        textView!.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.margin).isActive = true
        textView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.margin).isActive = true
        textView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.margin).isActive = true
        textView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.margin).isActive = true
        
        // Styling
        textView!.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 1)
        // Start with placeholder
        textView!.text = "add-new-snippet-alert-text-placeholder".localized
        textView!.textColor = Constants.placeholderColor
    }
    
    fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}

protocol AddSnippetViewControllerDelegate {
    
    // Notify delegate about new snippet creation
    func didAddNewSnippet(snippetText: String)
}

extension AddSnippetViewController : UITextViewDelegate {
    
    // Placeholder behavior, based on solution #2 from https://stackoverflow.com/questions/27652227/text-view-uitextview-placeholder-swift
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "add-new-snippet-alert-text-placeholder".localized
            textView.textColor = Constants.placeholderColor
            updateTextLengthLabel(text: String())
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            // Do not allow new lines
        else if text == "\n" {
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == Constants.placeholderColor && !text.isEmpty {
            textView.textColor = Constants.textColor
            textView.text = text
            updateTextLengthLabel(text: text)
        }
            // For every other case, the text should change with the usual
            // behavior...
        else {
            updateTextLengthLabel(text: updatedText)
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    // Make sure cursor is not placed elsewhere while showing placeholder
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == Constants.placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    // Updates the label with the correct length and validates the textView's text length against the given constaints
    func updateTextLengthLabel(text: String) {
        
        let lengthViolation = text.count == 0 || text.count > Constants.maximumSnippetLength
        
        // Do not allow snippets exceeding length
        navigationItem.rightBarButtonItem?.isEnabled = !lengthViolation
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = lengthViolation ? Constants.errorColor : Constants.textColor
        let attributedString = NSAttributedString(string: "\(text.count) / \(Constants.maximumSnippetLength)", attributes: attributes)
        snippetLengthLabel?.attributedText = attributedString
    }
    
}

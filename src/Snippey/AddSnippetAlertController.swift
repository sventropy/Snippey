//
//  AddSnippetAlertController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 26.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class AddSnippetAlertController: UIAlertController {
    
    var delegate : AddSnippetAlertControllerDelegate?
    var textView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // One textview to enter snippet
        
        // TODO textview with placeholder
        //            textField.placeholder = "add-new-snippet-alert-text-placeholder".localized
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width - Constants.viewMargin * 2, height: 120))
        textView?.textContainerInset = UIEdgeInsets.init(top: Constants.textAreaTopBottomInset, left: Constants.textAreaSideInset, bottom: Constants.textAreaTopBottomInset, right: Constants.textAreaSideInset)
        view.addSubview(textView!)
        textView?.translatesAutoresizingMaskIntoConstraints = false
        textView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 52).isActive = true
        textView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView?.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 224).isActive = true
        
        // Actions
        let confirmAction = UIAlertAction(title: "add-new-snippet-alert-add-button-label".localized, style: .default) { (_) in
            
            // Ensure textView is filled
            guard let snippetText = Util.findFirstSubviewOfTypeRecursive(view: self.view, targetType: UITextView.self)?.text
                else { return }
            
            // Notify delegate about update
            self.delegate?.didAddNewSnippet(snippetText: snippetText)
        }
        
        let cancelAction = UIAlertAction(title: "add-new-snippet-alert-cancel-button-label".localized, style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: OperationQueue.main) { (notification) in
            confirmAction.isEnabled = !(self.textView!.text.isEmpty)
        }
        
        // by default disable, enable when both fields valid
        confirmAction.isEnabled = false
        addAction(confirmAction)
        addAction(cancelAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView!.becomeFirstResponder()
    }
    
}

protocol AddSnippetAlertControllerDelegate {
    func didAddNewSnippet(snippetText: String)
}

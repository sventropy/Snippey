//
//  KeyboardViewController.swift
//  AsciiMojiKeyboard
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit
import Foundation

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Constants {
        static let cellReuseIdentifier = "emoticonCell"
        static let cornerRadius : CGFloat = 4.0
        static let keyboardBackgroundColor = UIColor(displayP3Red: 199/255, green: 203/255, blue: 210/255, alpha: 1)
        static let buttonBackgroundColor = UIColor.white
        static let textColor = UIColor.black
        static let shadowColor = UIColor(displayP3Red: 137/255, green: 139/255, blue: 143/255, alpha: 1)
        static let spacing : CGFloat = 4.0
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var keyboardSwitchButton: UIButton!
    @IBOutlet weak var spaceButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var toolBar: UIView!
    
    var emoticons: [Emoticon] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadAndSortEmoticons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.keyboardSwitchButton.backgroundColor = Constants.buttonBackgroundColor
        self.spaceButton.backgroundColor = Constants.buttonBackgroundColor
        self.backspaceButton.backgroundColor = Constants.buttonBackgroundColor
        self.returnButton.backgroundColor = Constants.buttonBackgroundColor
        self.keyboardSwitchButton.layer.cornerRadius = Constants.cornerRadius
        self.spaceButton.layer.cornerRadius = Constants.cornerRadius
        self.backspaceButton.layer.cornerRadius = Constants.cornerRadius
        self.returnButton.layer.cornerRadius = Constants.cornerRadius
        self.addShadowTo(self.keyboardSwitchButton)
        self.addShadowTo(self.spaceButton)
        self.addShadowTo(self.backspaceButton)
        self.addShadowTo(self.returnButton)
        
        self.tableView.backgroundColor = Constants.keyboardBackgroundColor
        self.toolBar.backgroundColor = Constants.keyboardBackgroundColor
    }
    
    @IBAction func keyboardSwitchTouchUp(_ sender: Any) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func returnTouchUp(_ sender: Any) {
        self.textDocumentProxy.insertText("\n")
    }
    
    @IBAction func spaceTouchUp(_ sender: Any) {
        self.textDocumentProxy.insertText(" ")
    }
    
    @IBAction func backspaceTouchUp(_ sender: Any) {
        self.textDocumentProxy.deleteBackward()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emoticons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath)
        
        // Configure the cell...
        let emoticon = self.emoticons[indexPath.row];
        cell.textLabel?.text = emoticon.emoticon
        cell.detailTextLabel?.text = emoticon.title
        
        return cell
    }
    
    func addShadowTo(_ view:UIView) -> Void {
        view.layer.shadowColor = Constants.shadowColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 0
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: Constants.cornerRadius).cgPath
        view.layer.masksToBounds = false
    }
    
    fileprivate func loadAndSortEmoticons() {
        self.emoticons = Persistence.sharedInstance.getEmoticons()
        self.emoticons.sort { (e1, e2) -> Bool in
            e1.emoticon.count < e2.emoticon.count
        }
        self.tableView.reloadData()
    }
    
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}

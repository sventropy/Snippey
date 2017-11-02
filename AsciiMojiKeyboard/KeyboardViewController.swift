//
//  KeyboardViewController.swift
//  AsciiMojiKeyboard
//
//  Created by Hennessen, Sven on 14.09.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit
import Foundation

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    struct Constants {
        static let cellReuseIdentifier = "emoticonCell"
        static let cornerRadius : CGFloat = 4.0
        static let keyboardBackgroundColor = UIColor(displayP3Red: 199/255, green: 203/255, blue: 210/255, alpha: 1)
        static let buttonBackgroundColor = UIColor.white
        static let textColor = UIColor.black
        static let shadowColor = UIColor(displayP3Red: 137/255, green: 139/255, blue: 143/255, alpha: 1)
        static let spacing : CGFloat = 4.0
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var keyboardSwitchButton: UIButton!
    @IBOutlet weak var spaceButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var bottomBar: UIView!
    
    var emoticons: [Emoticon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emoticons = Persistence.sharedInstance.getEmoticons()
        self.emoticons.sort { (e1, e2) -> Bool in
            e1.emoticon.count < e2.emoticon.count
        }
        self.collectionView.reloadData()
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
        
        self.collectionView.backgroundColor = Constants.keyboardBackgroundColor
        self.bottomBar.backgroundColor = Constants.keyboardBackgroundColor
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0,left: 0,bottom: -4,right: 0)
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
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let emoticon = self.emoticons[indexPath.row];
        
        // dummy label to calculate size
        let label = UILabel()
        label.text = emoticon.emoticon
        label.sizeToFit()
        
        let requiredSize = label.frame.size;
        let size = CGSize(width: requiredSize.width + 12, height: requiredSize.height + 12)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let bottom = Constants.spacing
        return UIEdgeInsets(top: Constants.spacing ,left: Constants.spacing ,bottom: bottom , right:Constants.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmoticonCollectionViewCell
        cell.view?.backgroundColor = Constants.textColor
        cell.label?.textColor = Constants.buttonBackgroundColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmoticonCollectionViewCell
        cell.view?.backgroundColor = Constants.buttonBackgroundColor
        cell.label?.textColor = Constants.textColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = self.emoticons[indexPath.row];

        self.textDocumentProxy.insertText(emoticon.emoticon)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! EmoticonCollectionViewCell
        
        // Configure the cell...
        let emoticon = self.emoticons[indexPath.row];
        cell.label?.text = emoticon.emoticon
        
        cell.view?.layer.cornerRadius = Constants.cornerRadius
        cell.view?.backgroundColor = Constants.buttonBackgroundColor
        self.addShadowTo(cell)
        cell.label?.textColor = Constants.textColor
        cell.label?.textAlignment = .center
        
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
    
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}

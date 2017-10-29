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
        static let backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        static let textColor = UIColor(white: 0.1, alpha: 1.0)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var keyboardSwitchButton: UIButton!
    @IBOutlet weak var spaceButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    
    var emoticons: [Emoticon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardSwitchButton.backgroundColor = Constants.backgroundColor
        self.spaceButton.backgroundColor = Constants.backgroundColor
        self.backspaceButton.backgroundColor = Constants.backgroundColor
        self.keyboardSwitchButton.layer.cornerRadius = Constants.cornerRadius
        self.spaceButton.layer.cornerRadius = Constants.cornerRadius
        self.backspaceButton.layer.cornerRadius = Constants.cornerRadius
        self.addShadowTo(self.keyboardSwitchButton)
        self.addShadowTo(self.spaceButton)
        self.addShadowTo(self.backspaceButton)
        
        self.emoticons = Persistence.sharedInstance.getEmoticons()
        self.emoticons.sort { (e1, e2) -> Bool in
            e1.emoticon.count < e2.emoticon.count
        }
    }
    
    @IBAction func keyboardSwitchTouchUp(_ sender: Any) {
        self.advanceToNextInputMode()
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
        let size = CGSize(width: requiredSize.width + 16, height: requiredSize.height + 16)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:8 ,left:8 ,bottom:8 ,right:8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmoticonCollectionViewCell
        cell.view?.backgroundColor = Constants.textColor
        cell.label?.textColor = Constants.backgroundColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmoticonCollectionViewCell
        cell.view?.backgroundColor = Constants.backgroundColor
        cell.label?.textColor = Constants.textColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = self.emoticons[indexPath.row];

        self.textDocumentProxy.insertText(emoticon.emoticon)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! EmoticonCollectionViewCell
        
        // Configure the cell...
        let emoticon = self.emoticons[indexPath.row];
        cell.label?.text = emoticon.emoticon
        
        cell.view?.layer.cornerRadius = Constants.cornerRadius
        cell.view?.backgroundColor = Constants.backgroundColor
        self.addShadowTo(cell)
        cell.label?.textColor = Constants.textColor
        cell.label?.textAlignment = .center
        
        return cell
    }
    
    func addShadowTo(_ view:UIView) -> Void {
        view.layer.masksToBounds = false
        view.layer.shadowColor = Constants.textColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.25)
        view.layer.shadowOpacity = 0.25
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: Constants.cornerRadius).cgPath
    }
    
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}

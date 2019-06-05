//
//  TextTableViewCell.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

// UITableViewCell implementation
class SnippetTableViewCell : UITableViewCell {
    
    // MARK: - Initialization
    
    // HACK: Alter behavior of initializing standard tableview cell in basic display
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initCellStyle()
        initCellBehavior()
        
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        initCellStyle()
        initCellBehavior()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Fix cell spacing by insets
        textLabel?.frame = textLabel!.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 16))
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    // MARK: - Private
    
    private func initCellBehavior() {
        
        // This tells the UITableViewCell label to show multiple lines
        textLabel?.numberOfLines = 0
    }

    private func initCellStyle() {
        // Style here, since to cumbersome via UIAppearance
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.shadowColor = Constants.darkColor.cgColor
        contentView.layer.shadowOpacity = Constants.shadowOpacity
        contentView.layer.shadowOffset = Constants.shadowOffset
        contentView.layer.borderColor = Constants.darkColor.cgColor
        contentView.layer.borderWidth = 1
        textLabel?.textColor = Constants.textColor
        backgroundColor = Constants.mediumColor
    }
}

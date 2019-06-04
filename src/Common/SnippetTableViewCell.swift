//
//  TextTableViewCell.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

// MARK: - UITableViewCell implementation

class SnippetTableViewCell : UITableViewCell {
    
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
    
    func initCellBehavior() {
        
        // This tells the UITableViewCell label to show multiple lines
        textLabel?.numberOfLines = 0
        
    }

    func initCellStyle() {
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = textLabel!.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 16))
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
}

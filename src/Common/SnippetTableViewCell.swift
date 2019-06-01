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
        initCellBehavior()
    }
    init() {
        super.init(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        initCellBehavior()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCellBehavior() {
        textLabel?.numberOfLines = 0
    }
}

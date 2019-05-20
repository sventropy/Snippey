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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    init() {
        super.init(style: .subtitle, reuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

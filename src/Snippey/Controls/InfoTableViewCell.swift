//
//  InfoTableViewCell.swift
//  Snippey
//
//  Created by Hennessen, Sven on 10.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// UITableViewCell implementation for both application and keyboard
class InfoTableViewCell: UITableViewCell {

        // MARK: - Initialization

        // HACK: Alter behavior of initializing standard tableview cell in basic display
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
        }

        init() {
            super.init(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
}

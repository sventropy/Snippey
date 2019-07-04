//
//  TextTableViewCell.swift
//  Snippey
//
//  Created by Hennessen, Sven on 20.05.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// UITableViewCell implementation for both application and keyboard
class SnippetTableViewCell: UITableViewCell {

    // MARK: - Initialization

    // HACK: Alter behavior of initializing standard tableview cell in basic display
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        applyCellBehavior()
    }

    init() {
        super.init(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        applyCellBehavior()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        // Fix cell spacing by insets
        textLabel?.frame = textLabel!.frame.inset(by:
            UIEdgeInsets(top: CGFloat.zero, left: CGFloat.zero,
                         bottom: Constants.margin / 2, right: Constants.margin * 2))
        contentView.frame = contentView.frame.inset(by:
            UIEdgeInsets(top: Constants.margin / 2, left: Constants.margin,
                         bottom: Constants.margin / 2, right: Constants.margin))
    }

    // MARK: - Private

    private func applyCellBehavior() {

        // This tells the UITableViewCell label to show multiple lines
        textLabel?.numberOfLines = Int.zero
    }

}

//
//  UIInsetLabel.swift
//  Snippey
//
//  Created by Hennessen, Sven on 05.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: Constants.margin, bottom: 0, right: Constants.margin)
        super.drawText(in: rect.inset(by: insets))
    }
    
}

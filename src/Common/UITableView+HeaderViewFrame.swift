//
//  UITableView+HeaderViewFrame.swift
//  Snippey
//
//  Created by Hennessen, Sven on 12.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// UITableView extension allowing to dynamically size the frame of the header view depending on its content
/// NOTE: App specific spacing included here
extension UITableView {
    func updateHeaderViewFrame() {
        if let header = tableHeaderView {
            // Adapt the frame to fit the rest of the design
            let newSize = header.systemLayoutSizeFitting(CGSize(width: bounds.width - Constants.margin * 4, height: CGFloat.zero))
            let adaptedSize = CGSize(width: newSize.width, height: newSize.height + Constants.margin * 2)
            let newFrame = CGRect(origin: CGPoint(x: Constants.margin * 3, y: CGFloat.zero), size: adaptedSize)
            header.frame = newFrame
        }
    }
}

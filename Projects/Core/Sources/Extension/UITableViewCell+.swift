//
//  UITableViewCell+.swift
//  Core
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//
//  CGFloat+.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

extension IntegerLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension FloatLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}

//
//  ReusableView+.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 https://github.com/gnksbm/Clone_AppStore. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

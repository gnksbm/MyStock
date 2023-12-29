//
//  WSEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol WSEndPoint: EndPoint { }

public extension WSEndPoint {
    var scheme: Scheme {
        .ws
    }
}

//
//  HTTPEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2024/01/08.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol HTTPEndPoint: RestfulEndPoint { }

public extension HTTPEndPoint {
    var scheme: Scheme {
        .http
    }
}

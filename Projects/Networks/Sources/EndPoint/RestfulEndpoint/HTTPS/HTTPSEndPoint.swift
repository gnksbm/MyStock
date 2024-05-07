//
//  HTTPSEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol HTTPSEndPoint: RestfulEndPoint { }

public extension HTTPSEndPoint {
    var scheme: Scheme {
        .https
    }
}

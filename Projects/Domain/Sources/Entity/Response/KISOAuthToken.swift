//
//  KISOAuthToken.swift
//  Domain
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISOAuthToken: Codable {
    public let token: String
    public let expireDate: Date
    
    public init(token: String, expireDate: Date) {
        self.token = token
        self.expireDate = expireDate
    }
}

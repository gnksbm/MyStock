//
//  KISUserInfo.swift
//  Domain
//
//  Created by gnksbm on 5/1/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct KISUserInfo: Codable {
    public let accountNum: String
    public let appKey: String
    public let secretKey: String
    
    public init(
        accountNum: String,
        appKey: String,
        secretKey: String
    ) {
        self.accountNum = accountNum
        self.appKey = appKey
        self.secretKey = secretKey
    }
}

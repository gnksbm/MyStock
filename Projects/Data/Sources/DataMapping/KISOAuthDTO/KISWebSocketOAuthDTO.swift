//
//  KISWebSocketOAuthDTO.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

struct KISWebSocketOAuthDTO: Codable, KISOAuthDTO {
    let approvalKey: String

    enum CodingKeys: String, CodingKey {
        case approvalKey = "approval_key"
    }
}

extension KISWebSocketOAuthDTO {
    var toDomain: KISOAuthToken {
        .init(
            token: approvalKey,
            expireDate: .now
        )
    }
}

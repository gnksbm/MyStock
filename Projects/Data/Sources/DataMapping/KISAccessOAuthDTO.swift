//
//  KISAccessOAuthDTO.swift
//  Data
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

struct KISAccessOAuthDTO: Codable {
    let accessToken: String
    let accessTokenTokenExpired: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenTokenExpired = "access_token_token_expired"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

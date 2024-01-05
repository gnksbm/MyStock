//
//  KISRealTimeStatusDTO.swift
//  Data
//
//  Created by gnksbm on 2024/01/04.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

struct KISRealTimeStatusDTO: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let rtCD, msgCD, msg1: String
    let output: Output
    
    enum CodingKeys: String, CodingKey {
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1, output
    }
}

// MARK: - Output
struct Output: Codable {
    let iv, key: String
}

// MARK: - Header
struct Header: Codable {
    let trID, trKey, encrypt: String
    
    enum CodingKeys: String, CodingKey {
        case trID = "tr_id"
        case trKey = "tr_key"
        case encrypt
    }
}

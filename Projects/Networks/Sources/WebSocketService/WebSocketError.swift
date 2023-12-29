//
//  WebSocketError.swift
//  Networks
//
//  Created by gnksbm on 2023/12/29.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

enum WebSocketError: LocalizedError {
    case invalidURL
    case unknownMessage
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .unknownMessage:
            return "알 수 없는 메세지입니다."
        }
    }
}

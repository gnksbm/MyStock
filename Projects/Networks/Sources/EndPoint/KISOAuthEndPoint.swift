//
//  KISOAuthEndPoint.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Core

public struct KISOAuthEndPoint: KISEndPoint {
    public var request: KISOAuthRequest
    
    public var path: String {
        switch request.oAuthType {
        case .webSocket:
            return "/oauth2/Approval"
        case .access:
            return "/oauth2/tokenP"
        }
    }
    
    public var query: [String : String] = [:]
    
    public var header: [String : String] {
        ["content-type": "application/json"]
    }
    
    public var body: Data? {
        let body = [
            "grant_type": "client_credentials",
            "appkey": .kisKey,
            "secretkey": .kisSecret
        ]
        guard let data = try? JSONEncoder().encode(body) else { return nil }
        return data
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public init(request: KISOAuthRequest) {
        self.request = request
    }
}

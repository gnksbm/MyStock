//
//  KISOAuthEndPoint.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct KISOAuthEndPoint: KISEndPoint {
    public var oAuthType: OAuthType
    public var investType: InvestType
    
    public var scheme: Scheme {
        .https
    }
    
    public var host: String {
        switch investType {
        case .reality:
            return "openapi.koreainvestment.com"
        case .simulation:
            return "openapivts.koreainvestment.com"
        }
    }
    
    public var port: String {
        switch investType {
        case .reality:
            return "9443"
        case .simulation:
            return "29443"
        }
    }
    
    public var path: String {
        switch oAuthType {
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
    
    init(oAuthType: OAuthType, investType: InvestType) {
        self.oAuthType = oAuthType
        self.investType = investType
    }
}

extension KISOAuthEndPoint {
    public enum OAuthType {
        case webSocket, access
    }
}

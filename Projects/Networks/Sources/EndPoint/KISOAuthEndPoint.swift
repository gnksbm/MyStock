//
//  KISOAuthEndPoint.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct KISOAuthEndPoint: EndPoint {
    public let investType: InvestType
    
    public var scheme: String {
        "https"
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
        "/oauth2/Approval"
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
    
    public init(investType: InvestType) {
        self.investType = investType
    }
    
}

public extension KISOAuthEndPoint {
    enum InvestType {
        case reality, simulation
    }
}

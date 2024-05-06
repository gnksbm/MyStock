//
//  LogoEndPoint.swift
//  Networks
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain
// https://eodhd.com/financial-apis-blog/40000-company-logos/
public struct LogoEndPoint: HTTPSEndPoint {
    private let request: LogoRequest
    
    public var host: String {
        "eodhd.com"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        var path = "/img/logos/"
        switch request.marketType {
        case .overseas:
            path += "US"
        case .domestic:
            path += "KO"
        }
        path += "/\(request.ticker.lowercased()).png"
        return path
    }
    
    public var query: [String : String] {
        [:]
    }
    
    public var header: [String : String] {
        [:]
    }
    
    public var body: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(request: LogoRequest) {
        self.request = request
    }
}

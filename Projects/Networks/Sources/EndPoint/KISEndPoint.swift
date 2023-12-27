//
//  KISEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

protocol KISEndPoint: EndPoint {
    var request: KISOAuthRequest { get set }
}

extension KISEndPoint {
    public var scheme: Scheme {
        .https
    }
    
    public var host: String {
        switch request.investType {
        case .reality:
            return "openapi.koreainvestment.com"
        case .simulation:
            return "openapivts.koreainvestment.com"
        }
    }
    
    public var port: String {
        switch request.investType {
        case .reality:
            return "9443"
        case .simulation:
            return "29443"
        }
    }
}

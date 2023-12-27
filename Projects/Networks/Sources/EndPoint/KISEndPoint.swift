//
//  KISEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

protocol KISEndPoint: EndPoint {
    var oAuthType: OAuthType { get set }
    var investType: InvestType { get set }
}

public enum OAuthType {
    case webSocket, access
}

public enum InvestType {
    case reality, simulation
}

extension KISEndPoint {
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
}

//
//  KISEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

protocol KISEndPoint: EndPoint {
    var investType: InvestType { get set }
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
}

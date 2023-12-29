//
//  KISEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

protocol KISEndPoint: EndPoint, HTTPSEndPoint {
    var investType: InvestType { get }
}

extension KISEndPoint {
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

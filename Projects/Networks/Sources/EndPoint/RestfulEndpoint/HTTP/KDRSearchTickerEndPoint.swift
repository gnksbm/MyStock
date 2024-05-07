//
//  KDRSearchTickerEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2024/01/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KDRSearchTickerEndPoint: HTTPEndPoint {
    let marketKind: MarketKind
    
    public var host: String {
        "api.seibro.or.kr"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/openapi/service/StockSvc/getKDRSecnInfo"
    }
    
    public var query: [String : String] {
        [
            "ServiceKey": .seibroKey,
            "caltotMartTpcd": marketKind.rawValue
        ]
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
    
    public init(marketKind: MarketKind) {
        self.marketKind = marketKind
    }
}

public extension KDRSearchTickerEndPoint {
    enum MarketKind: String {
        case kospi = "11"
        case kosdaq = "12"
        case konex = "13"
    }
}

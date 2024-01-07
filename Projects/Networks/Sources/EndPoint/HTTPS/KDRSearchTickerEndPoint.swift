//
//  KDRSearchTickerEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2024/01/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

struct KDRSearchTickerEndPoint: HTTPSEndPoint {
    let marketKind: MarketKind
    
    var host: String {
        "api.seibro.or.kr"
    }
    
    var port: String {
        ""
    }
    
    var path: String {
        "/openapi/service/StockSvc/getKDRSecnInfo"
    }
    
    var query: [String : String] {
        [
            "ServiceKey": .seibroKey,
            "caltotMartTpcd": marketKind.rawValue
        ]
    }
    
    var header: [String : String] {
        [:]
    }
    
    var body: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    public init(marketKind: MarketKind) {
        self.marketKind = marketKind
    }
}

extension KDRSearchTickerEndPoint {
    enum MarketKind: String {
        case kospi = "11"
        case kosdaq = "12"
        case konex = "13"
    }
}

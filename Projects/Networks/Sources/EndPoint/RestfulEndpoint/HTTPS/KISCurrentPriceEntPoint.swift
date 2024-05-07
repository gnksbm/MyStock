//
//  KISCurrentPriceEntPoint.swift
//  Networks
//
//  Created by gnksbm on 2024/01/06.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public struct KISCurrentPriceEntPoint: KISEndPoint {
    let investType: InvestType
    let token: String
    let ticker: String
    
    public var path: String {
        "/uapi/domestic-stock/v1/quotations/inquire-price"
    }
    
    public var query: [String : String]
    
    public var header: [String : String] {
        return [
            "content-type": "application/json",
            "authorization": token,
            "appkey": .appKey,
            "appsecret": .secretKey,
            "tr_id": "FHKST01010100"
        ]
        
    }
    
    public var body: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(
        investType: InvestType,
        token: String,
        ticker: String
    ) {
        self.investType = investType
        self.token = token
        self.ticker = ticker
        self.query = [
            "FID_COND_MRKT_DIV_CODE": "J",
            "FID_INPUT_ISCD": ticker,
        ]
    }
}

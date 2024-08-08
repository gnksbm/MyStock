//
//  KISTopMarketCapEndpoint.swift
//  Networks
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

public struct KISTopMarketCapEndpoint: KISEndPoint {
    let request: KISTopMarketCapRequest
    
    var investType: InvestType { .reality }
    public var path: String { "/uapi/domestic-stock/v1/ranking/market-cap" }
    public var query: [String : String] {
        [
            "FID_COND_MRKT_DIV_CODE": "J",
            "FID_COND_SCR_DIV_CODE": "20174",
            "FID_INPUT_DATE_1": ""
        ].merging {
            request.headers.map { $0.httpQuery }
        }
    }
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": "Bearer \(request.token)",
            "appkey": request.userInfo.appKey,
            "appsecret": request.userInfo.secretKey,
            "tr_id": "FHPST01740000",
            "custtype": "P"
        ]
    }
    public var body: [String : String] { [:] }
    public var method: HTTPMethod { .get }
    
    public init(request: KISTopMarketCapRequest) {
        self.request = request
    }
}

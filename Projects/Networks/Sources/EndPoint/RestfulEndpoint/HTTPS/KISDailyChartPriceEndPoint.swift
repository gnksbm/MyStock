//
//  KISDailyChartPriceEndPoint.swift
//  Networks
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Domain

public struct KISDailyChartPriceEndPoint: KISEndPoint {
    let request: KISDailyChartPriceRequest
    
    var investType: InvestType { .reality }
    
    public var path: String {
        "/uapi/domestic-stock/v1/quotations/inquire-time-itemchartprice"
    }
    public var query: [String : String] {
        [
            "FID_ETC_CLS_CODE": "",
            "FID_INPUT_HOUR_1": "090000",
            "FID_PW_DATA_INCU_YN": "N",
        ].merging {
            request.quries.toHTTPQuery
        }
    }
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": "Bearer \(request.token)",
            "appkey": request.userInfo.appKey,
            "appsecret": request.userInfo.secretKey,
            "tr_id": "FHKST03010200",
            "custtype": "P"
        ]
    }
    
    public var body: [String : String] { [:] }
    
    public var method: HTTPMethod { .get }
    
    public init(request: KISDailyChartPriceRequest) {
        self.request = request
    }
}

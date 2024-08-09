//
//  KISDomesticCurrentPriceEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2024/01/06.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

public struct KISDomesticCurrentPriceEndPoint: KISEndPoint {
    let request: KISDomesticCurrentPriceRequest
    var investType: InvestType { .reality }
    
    public var path: String {
        "/uapi/domestic-stock/v1/quotations/inquire-price"
    }
    
    public var query: [String : String] {
        request.queryHeader.toHTTPQuery
    }
    
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": request.token,
            "appkey": request.userInfo.appKey,
            "appsecret": request.userInfo.secretKey,
            "tr_id": "FHKST01010100"
        ]
        
    }
    
    public var body: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(request: KISDomesticCurrentPriceRequest) {
        self.request = request
    }
}

//
//  KISTopVolumeEndpoint.swift
//  Networks
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain

public struct KISTopVolumeEndpoint: KISEndPoint {
    let request: KISTopVolumeRequest
    
    var investType: InvestType { .reality }
    public var path: String { "/uapi/domestic-stock/v1/quotations/volume-rank" }
    public var query: [String : String] {
        [
            "FID_COND_MRKT_DIV_CODE": "J",
            "FID_COND_SCR_DIV_CODE": "20171",
            "FID_INPUT_DATE_1": ""
        ].merging {
            request.headers.map { $0.httpQuery }
        }
    }
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": request.token,
            "appkey": request.userInfo.appKey,
            "appsecret": request.userInfo.secretKey,
            "tr_id": "FHPST01710000",
            "custtype": "P"
        ]
    }
    public var body: [String : String] { [:] }
    public var method: HTTPMethod { .get }
    
    public init(request: KISTopVolumeRequest) {
        self.request = request
    }
}

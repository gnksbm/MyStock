//
//  HolidayEndPoint.swift
//  Networks
//
//  Created by gnksbm on 5/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain

// https://www.data.go.kr/data/15012690/openapi.do

public struct HolidayEndPoint: HTTPEndPoint {
    public let request: HolidayRequest
    
    public var host: String {
        "apis.data.go.kr"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/B090041/openapi/service/SpcdeInfoService/getRestDeInfo"
    }
    
    public var query: [String : String] {
        [
            "solYear": request.date.toString(dateFormat: "yyyy"),
            "solMonth": request.date.toString(dateFormat: "MM"),
            "ServiceKey": .seibroKey
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
    
    public init(
        request: HolidayRequest
    ) {
        self.request = request
    }
}

//
//  KISCheckBalanceEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Core

public struct KISCheckBalanceEndPoint: KISEndPoint {
    @UserDefaultsWrapper(
        key: .userInfo,
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    let investType: InvestType
    private let authorization: String
    
    public var path: String {
        "/uapi/domestic-stock/v1/trading/inquire-balance"
    }
    
    public var query: [String : String]
    
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": "Bearer \(authorization)", // "Bearer ..."
            "appkey": userInfo.appKey,
            "appsecret": userInfo.secretKey,
            "tr_id": investType.tradingID
        ]
    }
    
    public var body: [String: String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(
        investType: InvestType,
        query: [String : String],
        authorization: String
    ) {
        self.investType = investType
        self.query = query
        self.authorization = authorization
    }
}

fileprivate extension InvestType {
    var tradingID: String {
        switch self {
        case .reality:
            return "TTTC8434R"
        case .simulation:
            return "VTTC8434R"
        }
    }
}

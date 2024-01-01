//
//  KISChartPriceEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/30.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain

public struct KISChartPriceEndPoint: KISEndPoint {
    let investType: InvestType
    let period: PeriodType
    let ticker: String
    let startDate: String
    let endDate: String
    let authorization: String
    
    public var path: String {
        "/uapi/domestic-stock/v1/quotations/inquire-daily-itemchartprice"
    }
    
    public var query: [String : String] {
        [
            "fid_cond_mrkt_div_code": "J",
            "fid_input_date_1": startDate,
            "fid_input_date_2": endDate,
            "fid_input_iscd": ticker,
            "fid_org_adj_prc": "0", // 0: 수정주가, 1: 원주가
            "fid_period_div_code": period.rawValue
        ]
    }
    
    public var header: [String : String] {
        [
            "content-type": "application/json",
            "authorization": "Bearer \(authorization)",
            "appkey": .kisKey,
            "appsecret": .kisSecret,
            "tr_id": "FHKST03010100",
            "custtype": "P"
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
        period: PeriodType,
        ticker: String,
        startDate: String,
        endDate: String,
        authorization: String
    ) {
        self.investType = investType
        self.period = period
        self.ticker = ticker
        self.startDate = startDate
        self.endDate = endDate
        self.authorization = authorization
    }
}

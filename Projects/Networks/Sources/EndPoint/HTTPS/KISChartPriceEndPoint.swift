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
    let marketType: MarketType
    let period: PeriodType
    let ticker: String
    let startDate: String
    let endDate: String
    let authorization: String
    
    public var path: String {
        return marketType.chartPricePath
    }
    
    public var query: [String : String] {
        switch marketType {
        case .overseas:
            return [
                "FID_COND_MRKT_DIV_CODE": "N",
                "FID_INPUT_ISCD": ticker,
                "FID_INPUT_DATE_1": startDate,
                "FID_INPUT_DATE_2": endDate,
                "FID_PERIOD_DIV_CODE": period.rawValue,
            ]
        case .domestic:
            return [
                "fid_cond_mrkt_div_code": "J",
                "fid_input_date_1": startDate,
                "fid_input_date_2": endDate,
                "fid_input_iscd": ticker,
                "fid_org_adj_prc": "0", // 0: 수정주가, 1: 원주가
                "fid_period_div_code": period.rawValue
            ]
        }
    }
    
    public var header: [String : String] {
        let userDefaults = UserDefaults.standard
        let appKey = userDefaults.string(forKey: "appKey") ?? ""
        let secretKey = userDefaults.string(forKey: "secretKey") ?? ""
        switch marketType {
        case .overseas:
            return [
                "authorization": "Bearer \(authorization)",
                "appkey": appKey,
                "appsecret": secretKey,
                "tr_id": "FHKST03030100",
            ]
        case .domestic:
            return [
                "content-type": "application/json",
                "authorization": "Bearer \(authorization)",
                "appkey": appKey,
                "appsecret": secretKey,
                "tr_id": "FHKST03010100",
                "custtype": "P"
            ]
        }
    }
    
    public var body: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(
        investType: InvestType,
        marketType: MarketType,
        period: PeriodType,
        ticker: String,
        startDate: String,
        endDate: String,
        authorization: String
    ) {
        self.investType = investType
        self.marketType = marketType
        self.period = period
        self.ticker = ticker
        self.startDate = startDate
        self.endDate = endDate
        self.authorization = authorization
    }
}

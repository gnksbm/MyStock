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
    @UserDefaultsWrapper(
        key: .userInfo,
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    let request: KISChartPriceRequest
    
    public var path: String {
        return request.marketType.chartPricePath
    }
    
    public var query: [String : String] {
        switch request.marketType {
        case .overseas:
            return [
                "FID_COND_MRKT_DIV_CODE": "N",
                "FID_INPUT_ISCD": request.ticker,
                "FID_INPUT_DATE_1": request.startDate,
                "FID_INPUT_DATE_2": request.endDate,
                "FID_PERIOD_DIV_CODE": request.period.rawValue,
            ]
        case .domestic:
            return [
                "fid_cond_mrkt_div_code": "J",
                "fid_input_date_1": request.startDate,
                "fid_input_date_2": request.endDate,
                "fid_input_iscd": request.ticker,
                "fid_org_adj_prc": "0", // 0: 수정주가, 1: 원주가
                "fid_period_div_code": request.period.rawValue
            ]
        }
    }
    
    public var header: [String : String] {
        switch request.marketType {
        case .overseas:
            return [
                "authorization": "Bearer \(request.authorization)",
                "appkey": userInfo.appKey,
                "appsecret": userInfo.secretKey,
                "tr_id": "FHKST03030100",
            ]
        case .domestic:
            return [
                "content-type": "application/json",
                "authorization": "Bearer \(request.authorization)",
                "appkey": userInfo.appKey,
                "appsecret": userInfo.secretKey,
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
        request: KISChartPriceRequest
    ) {
        self.request = request
    }
}

extension KISChartPriceEndPoint {
    var investType: InvestType {
        request.investType
    }
}

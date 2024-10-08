//
//  KISRealTimePriceEndPoint.swift
//  Networks
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

/* https://apiportal.koreainvestment.com/apiservice/
 apiservice-domestic-stock-real2#L_714d1437-8f62-43db-a73c-cf509d3f6aa7
*/

import Foundation

import Domain
import Core

public struct KISRealTimePriceEndPoint: WSEndPoint {
    public var investType: InvestType
    public var marketType: MarketType
    
    public let approvalKey: String
    public let ticker: String
    
    public var scheme: Scheme {
        .ws
    }
    
    public var host: String {
        "ops.koreainvestment.com"
    }
    
    public var port: String {
        switch investType {
        case .reality:
            return "21000"
        case .simulation:
            return "31000"
        }
    }
    
    public var path: String {
        "/tryitout/\(tradingID)"
    }
    
    var tradingID: String {
        switch marketType {
        case .overseas:
            return "HDFSCNT0"
        case .domestic:
            return "H0STCNT0"
        }
    }
    
    public var query: [String: String] = [:]
    
    public var header: [String: String] {
        [
//            :
            "approval_key": approvalKey,
            "custtype": "P",
            "tr_type": "1",
            "content-type": "utf-8",
        ]
    }
    
    public var body: [String: String] {
        [
            :
//            "tr_id": "H0STASP0",
//            "tr_key": "005930"
        ]
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public init(
        approvalKey: String,
        ticker: String,
        investType: InvestType,
        marketType: MarketType
    ) {
        self.approvalKey = approvalKey
        self.ticker = ticker
        self.investType = investType
        self.marketType = marketType
    }
}

public extension KISRealTimePriceEndPoint {
    func dataToSend() throws -> Data {
        guard let dicJson = """
        {
                 "header":
                 {
                          "approval_key":"\(approvalKey)",
                          "custtype":"P",
                          "tr_type":"1",
                          "content-type":"utf-8"
                 },
                 "body":
                 {
                          "input":
                          {
                                   "tr_id":"\(tradingID)",
                                   "tr_key":"\(ticker)"
                          }
                 }
        }
        """.data(using: .utf8)
        else { throw WebSocketError.invalidURL }
        do {
            let json = try JSONSerialization.jsonObject(with: dicJson)
            return try JSONSerialization.data(withJSONObject: json)
        } catch {
            throw error
        }
    }
    
    var requestJson: Data? {
        let requestJson = RequestJson(
            header: .init(
                approvalKey: approvalKey,
                custType: "P",
                trType: "1",
                contentType: "utf-8"
            ),
            body: .init(
                trID: tradingID,
                trKey: ticker
            )
        )
        guard let dicJson = """
        {
                 "header":
                 {
                          "approval_key":"\(approvalKey)",
                          "custtype":"P",
                          "tr_type":"1",
                          "content-type":"utf-8"
                 },
                 "body":
                 {
                          "input":
                          {
                                   "tr_id":"\(tradingID)",
                                   "tr_key":"\(ticker)"
                          }
                 }
        }
        """.data(using: .utf8)
        else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: dicJson)
            if JSONSerialization.isValidJSONObject(json) {
                return try? JSONSerialization.data(withJSONObject: json)
            }
        } catch {
            print(error.localizedDescription)
        }
        return requestJson.encode()
    }
    
    struct RequestJson: Encodable {
        let header: Header
        let body: Body
    }
    
    struct Header: Encodable {
        let approvalKey: String
        let custType: String
        let trType: String
        let contentType: String
        
        enum CodingKeys: String, CodingKey {
            case approvalKey = "approval_key"
            case custType = "custtype"
            case trType = "tr_type"
            case contentType = "content-type"
        }
    }
    
    struct Body: Encodable {
        let trID: String
        let trKey: String
        
        enum CodingKeys: String, CodingKey {
            case trID = "tr_id"
            case trKey = "tr_key"
        }
    }
}

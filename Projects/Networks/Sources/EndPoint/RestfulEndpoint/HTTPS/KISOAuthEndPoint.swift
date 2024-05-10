//
//  KISOAuthEndPoint.swift
//  Network
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import Core

public struct KISOAuthEndPoint: KISEndPoint {
    @UserDefaultsWrapper(
        key: "kisUserInfo",
        defaultValue: KISUserInfo(
            accountNum: "",
            appKey: "",
            secretKey: ""
        )
    )
    private var userInfo: KISUserInfo
    
    let investType: InvestType
    
    let oAuthType: KISOAuthRequest.OAuthType
    
    public var path: String {
        switch oAuthType {
        case .webSocket:
            return "/oauth2/Approval"
        case .access:
            return "/oauth2/tokenP"
        }
    }
    
    public var query: [String : String] = [:]
    
    public var header: [String : String] {
        ["content-type": "application/json"]
    }
    
    public var body: [String: String] {
        [
            "grant_type": "client_credentials",
            "appkey": userInfo.appKey,
            secret: userInfo.secretKey
        ]
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public init(investType: InvestType, oAuthType: KISOAuthRequest.OAuthType) {
        self.investType = investType
        self.oAuthType = oAuthType
    }
}

extension KISOAuthEndPoint {
    var secret: String {
        switch oAuthType {
        case .access:
            return "appsecret"
        case .webSocket:
            return "secretkey"
        }
    }
}

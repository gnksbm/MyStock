//
//  KISOAuthRequest.swift
//  Domain
//
//  Created by gnksbm on 2023/12/28.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public struct KISOAuthRequest {
    public let oAuthType: OAuthType
    public let investType: InvestType
    
    public init(oAuthType: OAuthType, investType: InvestType) {
        self.oAuthType = oAuthType
        self.investType = investType
    }
}

public extension KISOAuthRequest {
    enum OAuthType: String {
        case webSocket, access
    }
}

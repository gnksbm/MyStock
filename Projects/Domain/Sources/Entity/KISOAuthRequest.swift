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
}

public extension KISOAuthRequest {
    enum OAuthType {
        case webSocket, access
    }
}

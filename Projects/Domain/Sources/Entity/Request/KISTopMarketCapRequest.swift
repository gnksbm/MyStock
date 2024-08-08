//
//  KISTopMarketCapRequest.swift
//  Domain
//
//  Created by gnksbm on 8/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct KISTopMarketCapRequest {
    public let token: String
    public let userInfo: KISUserInfo
    public let headers: [KISQueryRepresentable] = [
        KISInputISCode.all,
        KISDivisionCode.all,
        KISTargetClassCode.topMarketCap,
        KISTargetExcludeClassCode.topMarketCap,
        KISInputPrice.all,
        KISVolumeCount.all
    ]
}

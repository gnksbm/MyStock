//
//  KISTopVolumeRequest.swift
//  Domain
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct KISTopVolumeRequest {
    public let token: String
    public let userInfo: KISUserInfo
    public let headers: [KISQueryRepresentable] = [
        KISInputISCode.all,
        KISDivisionCode.all,
        KISBelongingClassCode.averageVolume,
        KISTargetClassCode.margin,
        KISTargetExcludeClassCode.investmentRisk,
        KISInputPrice.all,
        KISVolumeCount.all
    ]
}

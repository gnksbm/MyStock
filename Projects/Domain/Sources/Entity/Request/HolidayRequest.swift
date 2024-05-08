//
//  HolidayRequest.swift
//  Domain
//
//  Created by gnksbm on 5/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct HolidayRequest {
    public let date: Date
    
    public init(date: Date) {
        self.date = date
    }
}

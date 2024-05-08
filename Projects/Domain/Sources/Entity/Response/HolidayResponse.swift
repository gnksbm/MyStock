//
//  HolidayResponse.swift
//  Domain
//
//  Created by gnksbm on 5/8/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public struct HolidayResponse {
    public let date: Date
    public let isHoliday: Bool
    public let dateName: String?
    
    public init(
        date: Date,
        isHoliday: Bool,
        dateName: String?
    ) {
        self.date = date
        self.isHoliday = isHoliday
        self.dateName = dateName
    }
}

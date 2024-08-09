//
//  DateFormat.swift
//  Core
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public enum DateFormat: String {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    case dailyChartInput = "yyyyMMddHHmmss"
    case accessToken = "yyyy-MM-dd HH:mm:ss"
    case holiday = "yyyyMMdd"
    
    fileprivate var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = self.rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

public extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
    
    func formatted(input: DateFormat, output: DateFormat) -> String? {
        input.formatter.date(from: self)?.formatted(dateFormat: output)
    }
}

public extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
}


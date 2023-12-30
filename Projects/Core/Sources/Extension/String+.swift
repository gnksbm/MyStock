//
//  String+.swift
//  Core
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

public extension String {
    func checkPrice(point: Int) -> UIColor {
        guard let value = Int(self) else { return .black }
        if value == point {
            return .black
        } else if value > point {
            return .green
        } else {
            return .red
        }
    }
    
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self)
        else {
            fatalError("Invalid String to dateFormat")
        }
        return date
    }
    
    static var kisKey: Self {
        guard let kisKey = Bundle.main.object(
            forInfoDictionaryKey: "KIS_APP_KEY"
        ) as? String
        else { fatalError("실패") }
        return kisKey
    }
    
    static var kisSecret: Self {
        guard let kisSecret = Bundle.main.object(
            forInfoDictionaryKey: "KIS_APP_SECRET"
        ) as? String
        else { fatalError("실패") }
        return kisSecret
    }
}

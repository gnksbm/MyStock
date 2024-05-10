//
//  String+.swift
//  Core
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

public extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        guard let date = dateFormatter.date(from: self)
        else {
            fatalError("Invalid String to dateFormat")
        }
        return date
    }
    
    func toCurrency(style: NumberFormatter.Style) -> Self {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.locale = Locale(
            languageCode: .korean,
            languageRegion: .southKorea
        )
        guard let number = Int(self) else { return self }
        return formatter.string(from: number as NSNumber) ?? self
    }
    
    static var seibroKey: Self {
        guard let seibroKey = Bundle.main.object(
            forInfoDictionaryKey: "SEIBRO_APP_KEY"
        ) as? String
        else { fatalError("실패") }
        return seibroKey
    }
}

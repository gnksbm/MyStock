//
//  String+.swift
//  Core
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit

public extension String {
    func formatted(style: NumberFormatter.Style) -> Self {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.locale = Locale(
            languageCode: .korean,
            languageRegion: .southKorea
        )
        guard let number = Double(self) else { return self }
        return formatter.string(from: number as NSNumber) ?? self
    }
    
    func toPercent() -> Self {
        guard let rate = Double(self) else { return self }
        if rate > 0 {
            return "+ \(String(format: "%.2f", rate))%"
        } else {
            return "\(String(format: "%.2f", rate))%"
        }
    }
    
    static var seibroKey: Self {
        guard let seibroKey = Bundle.main.object(
            forInfoDictionaryKey: "SEIBRO_APP_KEY"
        ) as? String
        else { fatalError("실패") }
        return seibroKey
    }
}

//
//  LogoResponse.swift
//  Domain
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public struct LogoResponse {
    public let ticker: String
    public let image: UIImage?
    
    public init(
        ticker: String,
        image: UIImage?
    ) {
        self.ticker = ticker
        self.image = image
    }
}

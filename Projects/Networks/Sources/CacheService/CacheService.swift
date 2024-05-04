//
//  CacheService.swift
//  Networks
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public protocol CacheService {
    func cacheData(data: Data, endPoint: EndPoint)
    func getCachedData(endPoint: EndPoint) -> Data?
}

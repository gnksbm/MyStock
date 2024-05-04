//
//  DefualtCacheService.swift
//  Networks
//
//  Created by gnksbm on 5/5/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

public final class DefaultCacheService: CacheService {
    private let cache = NSCache<NSURL, NSData>()
    
    public init() { }
    
    public func getCachedData(endPoint: EndPoint) -> Data? {
        guard let url = endPoint.toURLRequest?.url else { return nil }
        return cache.object(forKey: url as NSURL) as? Data
    }
    
    public func cacheData(data: Data, endPoint: EndPoint) {
        guard let url = endPoint.toURLRequest?.url else { return }
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
}

//
//  EndPoint.swift
//  Data
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol EndPoint {
    var scheme: Scheme { get }
    var host: String { get }
    var port: String { get }
    var path: String { get }
    var query: [String: String] { get set }
    var header: [String: String] { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
}

public enum Scheme: String {
    case http, https
}

extension EndPoint {
    var toURLRequest: URLRequest? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme.rawValue
        urlComponent.host = host
        urlComponent.port = Int(port)
        urlComponent.path = path
        if !query.isEmpty {
            urlComponent.queryItems = query.map {
                .init(name: $0.key, value: $0.value)
            }
        }
        guard let url = urlComponent.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.toString
        urlRequest.httpBody = body
        header.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}

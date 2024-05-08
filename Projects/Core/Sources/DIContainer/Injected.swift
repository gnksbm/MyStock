//
//  Injected.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T {
        DIContainer.resolve(type: T.self)
    }
    
    public init() { }
}

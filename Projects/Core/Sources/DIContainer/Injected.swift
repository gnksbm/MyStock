//
//  Injected.swift
//  Core
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 https://github.com/gnksbm/Clone_AppStore. All rights reserved.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    private var type: T.Type
    
    var wrappedValue: T {
        DIContainer.resolve(type: type)
    }
    
    init(_ type: T.Type) {
        self.type = type
    }
}

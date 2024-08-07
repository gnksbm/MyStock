//
//  TypeBuilder.swift
//  Core
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

@resultBuilder
public enum TypeBuilder<T> {
    public static func buildBlock(_ components: T...) -> [T] {
        components
    }
    
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }
}

//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

public enum ModuleType {
    case app, framework, staticFramework, feature
    
    var product: Product {
        switch self {
        case .app:
            return .app
        case .framework:
            return .framework
        case .staticFramework:
            return .staticFramework
        case .feature:
            return .staticFramework
        }
    }
}

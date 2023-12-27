//
//  Dependency+Feature.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/11/23.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum Feature: CaseIterable {
//        case temp
        
        public var dependency: TargetDependency {
            switch self {
//            case .temp:
//                return featureModule(name: "temp")
            }
        }
        
        private func featureModule(name: String) -> TargetDependency {
            .project(
                target: "\(name)Feature",
                path: .relativeToRoot("Projects/Feature/\(name)Feature")
            )
        }
    }
}

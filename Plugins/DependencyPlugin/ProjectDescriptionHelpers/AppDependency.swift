//
//  AppDependency.swift
//  DependencyPlugin
//
//  Created by gnksbm on 5/14/24.
//

import ProjectDescription

public struct AppDependency {
    public static let app = getDependency(name: "App")
    public static let mainFeature = getDependency(name: "MainFeature")
    public static let core = getDependency(name: "Core")
    public static let data = getDependency(name: "Data")
    public static let domain = getDependency(name: "Domain")
    public static let networks = getDependency(name: "Networks")
    public static let coreDataService = getDependency(name: "CoreDataService")
    public static let featureDependency = getDependency(name: "FeatureDependency")
    public static let designSystem = getDependency(name: "DesignSystem")
    public static let thirdPartyLibs = getDependency(name: "ThirdPartyLibs")
    public static let thirdPartyDependencies = ThirdParty.allCases.map {
        TargetDependency.external(name: $0.dependencyName)
    }
    
    private static func getDependency(name: String) -> TargetDependency {
        .project(
            target: "\(name)",
            path: .relativeToRoot("Projects/\(name)")
        )
    }
    
    private static func getFeatureDependency(name: String) -> TargetDependency {
        .project(
            target: "\(name)Feature",
            path: .relativeToRoot("Projects/Feature/\(name)Feature")
        )
    }
}
// MARK: Feature Module
extension AppDependency {
    public static let features = Feature.allCases.map { $0.dependency }
    
    enum Feature: String, CaseIterable {
        case balance, favorites, settings, searchStock, chart, summary
        
        public var dependency: TargetDependency {
            var name = rawValue.map { $0 }
            name.removeFirst()
            name.insert(Character(rawValue.first!.uppercased()), at: 0)
            return getFeatureDependency(name: String(name))
        }
    }
}
// MARK: ThirdParty
extension AppDependency {
    public static let thirdPartySPM = SwiftPackageManagerDependencies(
        ThirdParty.allCases.map {
            .remote(
                url: $0.url,
                requirement: .exact($0.version)
            )
        },
        productTypes: [
            "RxCocoa": .framework,
            "RxCocoaRuntime": .framework,
            "CryptoSwift": .framework,
            "XMLCoder": .framework,
            "SnapKit": .framework,
            "ReactorKit": .framework,
            "WeakMapTable": .framework,
        ]
    )
    
    enum ThirdParty: CaseIterable {
        case rxCocoa, cryptoSwift, xmlCoder, snapKit, reactorKit
        
        public var dependencyName: String {
            switch self {
            case .rxCocoa:
                return "RxCocoa"
            case .cryptoSwift:
                return "CryptoSwift"
            case .xmlCoder:
                return "XMLCoder"
            case .snapKit:
                return "SnapKit"
            case .reactorKit:
                return "ReactorKit"
            }
        }
        
        public var url: String {
            switch self {
            case .rxCocoa:
                return "https://github.com/ReactiveX/RxSwift"
            case .cryptoSwift:
                return "https://github.com/krzyzanowskim/CryptoSwift"
            case .xmlCoder:
                return "https://github.com/CoreOffice/XMLCoder.git"
            case .snapKit:
                return "https://github.com/SnapKit/SnapKit.git"
            case .reactorKit:
                return "https://github.com/ReactorKit/ReactorKit.git"
            }
        }
        
        public var version: Version {
            switch self {
            case .rxCocoa:
                return "6.0.0"
            case .cryptoSwift:
                return "1.8.0"
            case .xmlCoder:
                return "0.17.1"
            case .snapKit:
                return "5.7.1"
            case .reactorKit:
                return "3.2.0"
            }
        }
    }
}

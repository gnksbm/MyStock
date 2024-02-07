//
//  Project+Templates.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

extension Project {
    // MARK: Refact
    public static func makeProject(
        name: String,
        moduleType: ModuleType,
        entitlementsPath: Path? = nil,
        isTestable: Bool = false,
        hasResource: Bool = false,
        dependencies: [TargetDependency]
    ) -> Self {
        var targets = [Target]()
        var target: Target
        var entitlements: Entitlements?
        if let entitlementsPath {
            entitlements = .file(path: entitlementsPath)
        }
        var isFeature = false
        switch moduleType {
        case .app:
            target = appTarget(
                name: name,
                entitlements: entitlements,
                dependencies: dependencies
            )
        case .framework, .staticFramework:
            target = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                productType: moduleType.product,
                dependencies: dependencies
            )
        case .feature:
            isFeature = true
            target = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                isFeature: isFeature,
                productType: moduleType.product,
                dependencies: dependencies
            )
        }
        targets.append(target)
        if isTestable {
            targets.append(
                unitTestTarget(
                    name: name,
                    isFeature: isFeature,
                    dependencies: [.target(target)]
                )
            )
        }
        return Project(name: name,
                organizationName: .organizationName,
                targets: targets
        )
    }
    
    private static func appTarget(
        name: String,
        entitlements: Entitlements?,
        dependencies: [TargetDependency]
    ) -> Target {
        let target: Target = .init(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: .bundleID,
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: entitlements,
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: .appDebug
        )
        return target
    }

    private static func demoAppTarget(
        name: String,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency]
    ) -> Target {
        let target: Target = .init(
            name: "\(name)DemoApp",
            platform: .iOS,
            product: .app,
            bundleId: .bundleID + ".\(name)DemoApp",
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: [
                "Demo/**",
                "Sources/**"
            ],
            entitlements: entitlements,
            scripts: [.featureSwiftLint],
            dependencies: dependencies
        )
        return target
    }

    private static func frameworkTarget(
        name: String,
        entitlements: Entitlements?,
        hasResource: Bool,
        isFeature: Bool = false,
        productType: Product,
        dependencies: [TargetDependency]
    ) -> Target {
        let target: Target = .init(
            name: name,
            platform: .iOS,
            product: productType,
            bundleId: .bundleID + ".\(name)",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            entitlements: entitlements,
            scripts: isFeature ? [.featureSwiftLint] : [.swiftLint],
            dependencies: dependencies
        )
        return target
    }
    
    private static func unitTestTarget(
        name: String,
        isFeature: Bool = false,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: .bundleID + ".\(name)Test",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Tests/**"],
            scripts: isFeature ? [.featureSwiftLint] : [.swiftLint],
            dependencies: dependencies
        )
    }
}

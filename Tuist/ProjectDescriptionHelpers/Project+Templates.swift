//
//  Project+Templates.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

import EnvironmentPlugin
import DependencyPlugin

extension Project {
    public static func makeProject(
        name: String,
        moduleType: ModuleType,
        entitlementsPath: Path? = nil,
        isTestable: Bool = false,
        hasResource: Bool = false,
        appExtensionTarget: [Target] = [],
        coreDataModel: CoreDataModel? = nil,
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
                dependencies: dependencies + appExtensionTarget.map {
                    TargetDependency.target(name: $0.name)
                }
            )
            appExtensionTarget.forEach {
                targets.append($0)
            }
        case .framework, .staticFramework:
            target = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                coreDataModel: coreDataModel,
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
                coreDataModel: coreDataModel,
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
        return Project(
            name: name,
            organizationName: AppEnvironment.organizationName,
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
            bundleId: AppEnvironment.bundleID,
            deploymentTarget: AppEnvironment.deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: entitlements,
            scripts: [AppEnvironment.swiftLint],
            dependencies: dependencies,
            settings: .appDebug
        )
        return target
    }

    public static func appExtensionTarget(
        name: String,
        plist: InfoPlist?,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target(
            name: name,
            platform: .iOS,
            product: .appExtension,
            bundleId: AppEnvironment.bundleID + ".\(name)",
            deploymentTarget: AppEnvironment.deploymentTarget,
            infoPlist: plist,
            sources: ["\(name)/**"],
            resources: resources,
            entitlements: entitlements,
            scripts: [AppEnvironment.swiftLint],
            dependencies: dependencies,
            settings: .settings(
                base: .init()
                    .setCodeSignManual()
                    .setProvisioning(),
                configurations: [
                    .debug(
                        name: .debug,
                        xcconfig: .relativeToRoot("XCConfig/\(name)_Debug.xcconfig")
                    ),
                    .release(
                        name: .release,
                        xcconfig: .relativeToRoot("XCConfig/\(name)_Release.xcconfig")
                    ),
                ]
            )
        )
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
            bundleId: AppEnvironment.bundleID + ".\(name)DemoApp",
            deploymentTarget: AppEnvironment.deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: [
                "Demo/**",
                "Sources/**"
            ],
            entitlements: entitlements,
            scripts: [AppEnvironment.featureSwiftLint],
            dependencies: dependencies
        )
        return target
    }

    private static func frameworkTarget(
        name: String,
        entitlements: Entitlements?,
        hasResource: Bool,
        isFeature: Bool = false,
        coreDataModel: CoreDataModel?,
        productType: Product,
        dependencies: [TargetDependency]
    ) -> Target {
        let target: Target = .init(
            name: name,
            platform: .iOS,
            product: productType,
            bundleId: AppEnvironment.bundleID + ".\(name)",
            deploymentTarget: AppEnvironment.deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            entitlements: entitlements,
            scripts: isFeature ? [AppEnvironment.featureSwiftLint] : [AppEnvironment.swiftLint],
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
            bundleId: AppEnvironment.bundleID + ".\(name)Test",
            deploymentTarget: AppEnvironment.deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Tests/**"],
            scripts: isFeature ? [AppEnvironment.featureSwiftLint] : [AppEnvironment.swiftLint],
            dependencies: dependencies
        )
    }
}

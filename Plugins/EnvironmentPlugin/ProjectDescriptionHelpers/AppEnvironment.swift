//
//  AppEnvironment.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 5/16/24.
//

import ProjectDescription

public struct AppEnvironment {
    public static let appName = "KISStock"
    public static let displayName = "Stock"
    public static let organizationName = "GeonSeobKim"
    public static let deploymentTarget: DeploymentTarget = .iOS(
        targetVersion: "16.0",
        devices: .iphone
    )
    public static let bundleID = "com.\(organizationName).\(appName)"

    /// 앱스토어에 게시할 때마다 증가해줘야 하는 버전
    static let marketingVersion = "0.1.0"
    /// 개발자가 내부적으로 확인하기 위한 용도 (날짜를 사용하기도 함 - 2023.12.8.1 )
    static var buildVersion: String {
        "1.0"
    }
}

public extension AppEnvironment {
    static let swiftLint = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell",
        basedOnDependencyAnalysis: false
    )
    static let featureSwiftLint = TargetScript.pre(
        path: .relativeToRoot("Scripts/FeatureSwiftLintRunScript.sh"),
        name: "SwiftLintShell",
        basedOnDependencyAnalysis: false
    )
}

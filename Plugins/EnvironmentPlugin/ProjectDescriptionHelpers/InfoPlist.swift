//
//  InfoPlist.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/19.
//  Copyright © 2023 https://github.com/gnksbm/Clone_AppStore. All rights reserved.
//

import ProjectDescription

public extension InfoPlist {
    static let appInfoPlist: Self = .extendingDefault(
        with: .appInfoPlist
            .merging(.additionalInfoPlist) { oldValue, newValue in
                newValue
            }
            .merging(.secrets) { oldValue, newValue in
                newValue
            }
    )
    static let frameworkInfoPlist: Self = .extendingDefault(
        with: .framework
            .merging(.secrets) { oldValue, newValue in
                newValue
            }
    )
    static let widgetInfoPlist: Self = .extendingDefault(
        with: .widget
            .merging(.additionalInfoPlist) { oldValue, newValue in
                newValue
            }
            .merging(.secrets) { oldValue, newValue in
                newValue
            }
    )
}

public extension [String: Plist.Value] {
    static let secrets: Self = [
        "SEIBRO_APP_KEY": "$(SEIBRO_APP_KEY)",
    ]
    
    static let additionalInfoPlist: Self = [
        "ITSAppUsesNonExemptEncryption": "NO",
        "NSAppTransportSecurity": [
            "NSExceptionDomains": [
                "ops.koreainvestment.com": [
                    "NSIncludesSubdomains": true,
                    "NSExceptionAllowsInsecureHTTPLoads": true,
                    "NSTemporaryExceptionAllowsInsecureWebSocketLoads": true
                ],
                "apis.data.go.kr": [
                    "NSIncludesSubdomains": true,
                    "NSExceptionAllowsInsecureHTTPLoads": true,
                ]
            ]
        ],
    ]
    
    static let appInfoPlist: Self = [
        "CFBundleDisplayName": .string(AppEnvironment.displayName),
        "CFBundleShortVersionString": .string(AppEnvironment.marketingVersion),
        "CFBundleVersion": .string(AppEnvironment.buildVersion),
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIBackgroundModes": [
            "remote-notification"
        ],
        "NSCameraUsageDescription": "QR코드를 인식하기 위해 카메라 사용 권한이 필요합니다.",
    ]
    
    static let framework: Self = [
        "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
        "CFBundleExecutable": "$(EXECUTABLE_NAME)",
        "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
        "CFBundleInfoDictionaryVersion": "6.0",
        "CFBundleName": "$(PRODUCT_NAME)",
        "CFBundlePackageType": "FMWK",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
    ]
    
    static let widget: Self = [
        "CFBundleDisplayName": .string(AppEnvironment.displayName),
        "CFBundleShortVersionString": .string(AppEnvironment.marketingVersion),
        "CFBundleVersion": .string(AppEnvironment.buildVersion),
        "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
        "NSExtension": [
            "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
        ],
    ]
}

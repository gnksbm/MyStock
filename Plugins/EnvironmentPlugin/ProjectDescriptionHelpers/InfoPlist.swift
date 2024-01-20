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
        with: .baseInfoPlist
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
}

public extension [String: InfoPlist.Value] {
    static let secrets: Self = [
        "ACCOUNT_NUMBER": "$(ACCOUNT_NUMBER)",
        "KIS_APP_KEY": "$(KIS_APP_KEY)",
        "KIS_APP_SECRET": "$(KIS_APP_SECRET)",
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
                ]
            ]
        ]
    ]
    
    static let baseInfoPlist: Self = [
        "CFBundleDisplayName": .bundleDisplayName,
        "CFBundleShortVersionString": .bundleShortVersionString,
        "CFBundleVersion": .bundleVersion,
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
}

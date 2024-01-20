//
//  Dependencies.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

import EnvironmentPlugin
import DependencyPlugin

let carthage = CarthageDependencies(
    [
    ]
)

let thirdParty: [String: Product] = {
    let names = Array<TargetDependency>.ThirdPartyExternal.allCases
        .map { $0.name }
    let productType = Array(repeating: Product.framework, count: names.count)
    return Dictionary(
        uniqueKeysWithValues: zip(
            names,
            productType
        )
    )
}()

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: SwiftPackageManagerDependencies(
        .ThirdPartyRemote.SPM.allCases.map {
            Package.remote(
                url: $0.url,
                requirement: .upToNextMajor(from: $0.upToNextMajor)
            )
        }
//        ,
//        productTypes: thirdParty
    ),
    platforms: [.iOS]
)
//SwiftPackageManagerDependencies(
//    <#T##packages: [Package]##[Package]#>,
//    productTypes: <#T##[String : Product]#>,
//    baseSettings: <#T##Settings#>,
//    targetSettings: <#T##[String : SettingsDictionary]#>,
//    projectOptions: <#T##[String : Project.Options]#>
//)

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

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: AppDependency.thirdPartySPM,
    platforms: [.iOS]
)

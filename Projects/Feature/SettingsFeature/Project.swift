import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "SettingsFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "BalanceFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

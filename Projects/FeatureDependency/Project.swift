import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "FeatureDependency",
    moduleType: .framework,
    dependencies: [
        AppDependency.domain,
        AppDependency.designSystem
    ]
)

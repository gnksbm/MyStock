import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "DesignSystem",
    moduleType: .framework,
    hasResource: true,
    dependencies: [
        AppDependency.core
    ]
)

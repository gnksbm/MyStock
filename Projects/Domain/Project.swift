import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "Domain",
    moduleType: .framework,
    dependencies: [
        AppDependency.core
    ]
)

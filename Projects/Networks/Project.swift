import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "Networks",
    moduleType: .framework,
    dependencies: [
        AppDependency.domain,
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "Core",
    moduleType: .framework,
    dependencies: [
        AppDependency.thirdPartyLibs
    ]
)

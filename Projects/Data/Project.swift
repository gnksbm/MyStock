import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "Data",
    moduleType: .staticFramework,
    dependencies: [
        AppDependency.networks,
        AppDependency.coreDataService
    ]
)

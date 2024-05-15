import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "CoreDataService",
    moduleType: .framework,
    dependencies: [
        AppDependency.domain
    ]
)

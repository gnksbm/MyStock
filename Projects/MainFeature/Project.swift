import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .staticFramework,
    dependencies: AppDependency.features
)

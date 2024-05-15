import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "ThirdPartyLibs",
    moduleType: .framework,
    dependencies: AppDependency.thirdPartyDependencies
)

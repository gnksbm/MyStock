import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "DetailFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

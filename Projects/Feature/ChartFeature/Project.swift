import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "ChartFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

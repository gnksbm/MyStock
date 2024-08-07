import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "SummaryFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

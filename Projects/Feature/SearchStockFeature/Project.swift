import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "SearchStockFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

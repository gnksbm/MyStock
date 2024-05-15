import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

let project = Project.makeProject(
    name: "FavoritesFeature",
    moduleType: .feature,
    dependencies: [
        AppDependency.featureDependency
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "FavoritesFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)

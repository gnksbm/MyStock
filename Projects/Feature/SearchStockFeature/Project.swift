import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "SearchStockFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)

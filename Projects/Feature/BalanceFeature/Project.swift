import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "BalanceFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)

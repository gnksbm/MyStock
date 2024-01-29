import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "ChartFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "tempFeature",
    moduleType: .feature,
    dependencies: [
        .featureDependency
    ]
)

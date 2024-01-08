import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    hasResource: true,
    dependencies: [
        .mainFeature,
        .data,
        .domain,
    ]
)

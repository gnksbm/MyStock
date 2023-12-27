import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    hasResource: true,
    dependencies: [
        .data,
    ] + .Feature.allCases.map({ $0.dependency })
)

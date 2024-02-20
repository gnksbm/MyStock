import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    hasResource: true,
    coreDataModel: .init("Resources/Model.xcdatamodeld"),
    dependencies: [
        .mainFeature,
        .data,
        .domain,
    ]
)

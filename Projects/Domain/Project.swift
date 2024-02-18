import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "Domain",
    moduleType: .framework,
    hasResource: true,
    coreDataModel: .init("Resources/Model.xcdatamodeld"),
    dependencies: [
        .core
    ]
)

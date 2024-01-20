import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .staticFramework,
    dependencies: .Feature.allCases.map { $0.dependency }
)

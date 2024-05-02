import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    hasResource: true,
    appExtensionTarget: [
        Project.appExtensionTarget(
            name: "Widget",
            plist: .widgetInfoPlist,
            resources: [
                "Resources/Model.xcdatamodeld",
                "Widget/Resources/**",
            ],
            dependencies: [
                .mainFeature,
                .data,
            ]
        )
    ],
    coreDataModel: .init("Resources/Model.xcdatamodeld"),
    dependencies: [
        .mainFeature,
        .data,
        .domain,
    ]
)

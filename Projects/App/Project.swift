import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "App",
    moduleType: .app,
    entitlementsPath: .relativeToCurrentFile("App.entitlements"),
    hasResource: true,
    appExtensionTarget: [
        Project.appExtensionTarget(
            name: "Widget",
            plist: .widgetInfoPlist,
            resources: [
                "Resources/Model.xcdatamodeld",
                "Widget/Resources/**",
            ],
            entitlements: .file(
                path: .relativeToCurrentFile("Widget/Widget.entitlements")
            ),
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

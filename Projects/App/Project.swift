import ProjectDescription
import ProjectDescriptionHelpers

import DependencyPlugin

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
                AppDependency.mainFeature,
                AppDependency.data,
            ]
        )
    ],
    coreDataModel: .init("Resources/Model.xcdatamodeld"),
    dependencies: [
        AppDependency.mainFeature,
        AppDependency.data,
        AppDependency.domain,
    ]
)

//
//  Project+KlarnaTemplates.swift
//  ProjectDescriptionHelpers
//
//  Created by Jorge Palacio on 2024-10-10.
//

import ProjectDescription

/// Klarna list of internal libraries.
public enum KlarnaLibraries: String {
    case core = "KlarnaiOSCore"
    case nativeFunctions = "KlarnaNativeFunctions"
    case webCore = "KlarnaWebCore"
}

/// Klarna list of public native iOS SDKs.
public enum KlarnaSDKs: String {
    case hybrid
    case payments = "KlarnaPaymentsSDK"
}

/// Url to download the latest version of the config JSON file.
public let configURL: String = "https://x.klarnacdn.net/mobile-sdk/sdk-client-configuration/v2/configuration/config.json"

/// Script to download files at build time, during the build phases.
public let downloadScriptPath: Path = .relativeToRoot("scripts/BuildPhases/download-script.sh")
/// Config file output name

/// Target script to be run in the build phases at every build
public func configFileScript(projectName: String) -> TargetScript {
    let configFileName: String = "${SOURCE_ROOT:?}/\(projectName)/Resources/config.json"
    return .pre(
        path: downloadScriptPath,
        arguments: configURL, configFileName,
        name: "Config JSON Script",
        basedOnDependencyAnalysis: false
    )
}

extension Project {
    
    /// Helper method to create an internal klarna library.
    public static func klarnaFramework(
        targetName: KlarnaLibraries,
        dependencies: [ProjectDescription.TargetDependency] = [],
        scripts: [ProjectDescription.TargetScript] = []
    ) -> Project {
        return .framework(targetName: targetName.rawValue, dependencies: dependencies, scripts: scripts)
    }
    
    /// Helper method to create a klarna public framework which can depend on one or more internal libraries.
    public static func klarnaPublicFramework(
        name: KlarnaSDKs,
        dependencies: [ProjectDescription.TargetDependency] = [],
        scripts: [ProjectDescription.TargetScript] = []
    ) -> Project {
        return .framework(targetName: name.rawValue, dependencies: dependencies, scripts: scripts)
    }
    
    /// Helper method to create a test app.
    public static func klarnaTestApp(targetName: String, dependencies: [ProjectDescription.TargetDependency]) -> Project {
        return Project(
            name: targetName,
            settings: .settings(configurations: makeDefaultConfigurations()),
            targets: [
                .target(
                    name: targetName+" Dev",
                    destinations: Set(Destination.allCases.map{ $0 }),
                    product: .app,
                    bundleId: "com.klarnamsdk.dev.testapp",
                    deploymentTargets: .iOS("13.0"),
                    infoPlist: .default,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: dependencies
                )
            ]
        )
    }
    
    /// Helper method to create default configurations to the new projects.
    public static func makeDefaultConfigurations() -> [Configuration] {
        let debug = Configuration.debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig")
        let release = Configuration.release(name: "Release", xcconfig: "Configs/Release.xcconfig")
        return [debug, release]
    }
    
    private static func framework(
        targetName: String,
        dependencies: [ProjectDescription.TargetDependency] = [],
        scripts: [ProjectDescription.TargetScript] = []
    ) -> Project {
        // Destinations of the project sets the supported destination options
        let destinations = Set([Destination.iPad, Destination.iPhone])
        // Main target of the library
        let mainTarget: Target = .target(
            name: targetName,
            destinations: destinations,
            product: .framework,
            bundleId: .bundleId(for: targetName),
            deploymentTargets: .iOS("13.0"),
            // We update the plist with the values of the config files
            infoPlist: "\(targetName)/Info.plist",
            sources: ["\(targetName)/Sources/**"],
            resources: ["\(targetName)/Resources/**"],
            headers: .headers(public: .list([.glob(.path("\(targetName)/\(targetName).h"))])),
            scripts: scripts,
            dependencies: dependencies
        )
        // Unit tests target of the library project
        let testsTarget: Target = .target(
            // Add the tests value at the end of the name
            name: "\(targetName)Tests",
            // We use the same destinations
            destinations: destinations,
            product: .unitTests,
            bundleId: .bundleId(for: targetName, isTestTarget: true),
            infoPlist: "\(targetName)Tests/Info.plist",
            sources: ["\(targetName)Tests/**"],
            resources: ["\(targetName)/Resources/**"],
            headers: .headers(public: .list([.glob(.path("\(targetName)Tests/\(targetName)Tests.h"))])),
            // We add the library as a dependency
            dependencies: [.target(name: targetName)]
        )
        
        // Create the build action for the main target
        let buildAction: BuildAction = .buildAction(targets: [.target(targetName)])
        // Declare a target reference for the test action
        let target: TargetReference = .target("\(targetName)Tests")
        // Create the test action with coverage enabled and specifying the coverage target
        let testAction: TestAction = .targets(
            [.testableTarget(target: target, isParallelizable: false)],
            options: .options(coverage: true, codeCoverageTargets: [.target(targetName)])
        )

        return Project(
            name: targetName,
            // Disable automatic schemes to create our custom one,
            // if not will endup with 1 scheme per target
            options: .options(automaticSchemesOptions: .disabled),
            settings: Settings.settings(configurations: makeDefaultConfigurations()),
            targets: [mainTarget, testsTarget],
            // Set our custom scheme with the build and test actions
            schemes: [.scheme(name: targetName, buildAction: buildAction, testAction: testAction)]
        )
    }
}

extension String {
    /// Added function to create an easy an consistent bundle id for each project and the test target.
    public static func bundleId(for target: String, isTestTarget: Bool = false) -> String {
        let bundleValue = "com.klarnamsdk.\(target.lowercased())"
        guard isTestTarget else {
            return bundleValue
        }
        return bundleValue+"Tests"
    }
}

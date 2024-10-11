import ProjectDescription
import ProjectDescriptionHelpers

let wrapperURL: String = "https://x.klarnacdn.net/mobile-sdk/klarna-mobile-sdk-payments-wrapper-v2/v1/index.html"
let wrapperFileName: String = "${SOURCE_ROOT:?}/KlarnaPaymentsSDK/Resources/PaymentsWrapper.html"
let wrapperScript: TargetScript = .pre(
    path: downloadScriptPath,
    arguments: wrapperURL, wrapperFileName,
    name: "Update Local Files Script",
    basedOnDependencyAnalysis: false
)

let paymentsFramework: Project = .klarnaPublicFramework(
    name: .payments,
    dependencies: [
        .project(
            target: KlarnaLibraries.core.rawValue,
            path: .relativeToRoot("Libraries/\(KlarnaLibraries.core.rawValue)"),
            status: .required
        ),
        .project(
            target: KlarnaLibraries.nativeFunctions.rawValue,
            path: .relativeToRoot("Libraries/\(KlarnaLibraries.nativeFunctions.rawValue)"),
            status: .required
        ),
        .project(
            target: KlarnaLibraries.webCore.rawValue,
            path: .relativeToRoot("Libraries/\(KlarnaLibraries.webCore.rawValue)"),
            status: .required
        )
    ],
    scripts: [configFileScript(projectName: KlarnaSDKs.payments.rawValue), wrapperScript]
)

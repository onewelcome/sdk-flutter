import Foundation

class MainAppConnector {
    private(set) var factory: MainAppConnectorFactoryProtocol
    private var startAppConnector: StartAppConnectorProtocol
    private var resourcesConnector: ResourcesConnectorProtocol

    init(factory: MainAppConnectorFactoryProtocol = DefaultMainConnectorFactory()) {
        self.factory = factory
        startAppConnector = self.factory.startAppConnector
        resourcesConnector = self.factory.resourcesConnector
    }

    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        startAppConnector.startApp(call, result)
    }

    func fetchResources(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        resourcesConnector.fetchResources(call, result)
    }
}

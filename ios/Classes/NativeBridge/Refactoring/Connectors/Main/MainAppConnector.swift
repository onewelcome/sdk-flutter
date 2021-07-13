import Foundation

class MainAppConnector {
    private(set) var factory: MainAppConnectorFactoryProtocol
    private var startAppConnector: StartAppConnectorProtocol

    init(factory: MainAppConnectorFactoryProtocol? = nil) {
        self.factory = factory ?? DefaultMainConnectorFactory()
        startAppConnector = self.factory.startAppConnector
    }

    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        startAppConnector.startApp(call, result)
    }
}

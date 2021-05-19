import Foundation

class MainAppConnector {
    private(set) var factory: MainAppConnectorFactoryInterface
    
    init(factory: MainAppConnectorFactoryInterface? = nil) {
        self.factory = factory ?? DefaultMainConnectorFactory()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.startAppConnector.startApp(call, result)
    }
}

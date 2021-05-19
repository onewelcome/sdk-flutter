import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get }
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol {
        return StartAppConnector()
    }
}

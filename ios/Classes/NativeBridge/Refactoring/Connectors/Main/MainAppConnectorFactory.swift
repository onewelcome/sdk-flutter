import Foundation

protocol MainAppConnectorFactoryProtocol {
    var startAppConnector: StartAppConnectorProtocol { get }
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryProtocol {
    var startAppConnector: StartAppConnectorProtocol {
        return StartAppConnector()
    }
}

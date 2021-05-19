import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get }
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryInterface {
    lazy var startAppConnector: StartAppConnectorProtocol = {
        return StartAppConnector()
    }()
}

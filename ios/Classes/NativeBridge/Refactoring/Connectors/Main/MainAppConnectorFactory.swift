import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get }
    var resourcesConnector: ResourcesConnectorProtocol { get }
    var disconnectConnector: DisconnectConnectorProtocol { get }
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryProtocol {
    var startAppConnector: StartAppConnectorProtocol {
        return StartAppConnector()
    }

    var resourcesConnector: ResourcesConnectorProtocol {
        return ResourcesConnector()
    }()
    
    var disconnectConnector: DisconnectConnectorProtocol = {
        return DisconnectConnector()
    }
}

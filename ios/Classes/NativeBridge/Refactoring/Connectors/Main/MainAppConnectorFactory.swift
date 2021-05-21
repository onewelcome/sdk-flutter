import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get set}
    var resourcesConnector: ResourcesConnectorProtocol { get set}
    var disconnectConnector: DisconnectConnectorProtocol { get set}
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryInterface {
    lazy var startAppConnector: StartAppConnectorProtocol = {
        return StartAppConnector()
    }()
    
    lazy var resourcesConnector: ResourcesConnectorProtocol = {
        return ResourcesConnector()
    }()
    
    lazy var disconnectConnector: DisconnectConnectorProtocol = {
        return DisconnectConnector()
    }()
}

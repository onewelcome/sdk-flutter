import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get set}
    var resourcesConnector: ResourcesConnectorProtocol { get set}
    var disconnectConnector: DisconnectConnectorProtocol { get set}
    var identityProviderConnector: IdentityProviderConnectorProtocol { get }
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
    
    var identityProviderConnector: IdentityProviderConnectorProtocol {
        return IdentityProviderConnector()
    }
    
}

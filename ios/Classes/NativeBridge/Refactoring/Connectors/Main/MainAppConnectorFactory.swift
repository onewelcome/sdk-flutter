import Foundation

protocol MainAppConnectorFactoryProtocol {
    var startAppConnector: StartAppConnectorProtocol { get }
    var resourcesConnector: ResourcesConnectorProtocol { get }
}

class DefaultMainConnectorFactory: MainAppConnectorFactoryProtocol {
    var startAppConnector: StartAppConnectorProtocol {
        return StartAppConnector()
    }

    var resourcesConnector: ResourcesConnectorProtocol {
        return ResourcesConnector()
    }
}

import Foundation

protocol MainAppConnectorFactoryInterface {
    var startAppConnector: StartAppConnectorProtocol { get set}
    var resourcesConnector: ResourcesConnectorProtocol { get set}
    var disconnectConnector: DisconnectConnectorProtocol { get set}
    var identityProviderConnector: IdentityProviderConnectorProtocol { get}
    var userProfilesConnector: UserProfilesConnectorProtocol { get}
    var appToWebSingleSignOnConnector: AppToWebSingleSignOnConnectorProtocol { get}
    var authenticatorConnector: AuthenticatorConnectorProtocol { get}
    var pinConnector: PinConnectorProtocol { get}
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
    
    var userProfilesConnector: UserProfilesConnectorProtocol {
        return UserProfilesConnector()
    }
    
    var appToWebSingleSignOnConnector: AppToWebSingleSignOnConnectorProtocol {
        return AppToWebSingleSignOnConnector()
    }
    
    var authenticatorConnector: AuthenticatorConnectorProtocol {
        return AuthenticatorConnector()
    }
    
    var pinConnector: PinConnectorProtocol {
        return NewPinConnector()
    }
}

import OneginiSDKiOS

protocol RegistrationConnectorToHandlerProtocol: RegistrationHandlerToPinHanlderProtocol {
    func registerUser(_ providerId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void)
    func processRedirectURL(url: String, webSignInType: WebSignInType)
    func cancelBrowserRegistration()
    func logout(completion: @escaping (SdkError?) -> Void)
    func deregister(profileId: String, completion: @escaping (SdkError?) -> Void)
    func identityProviders() -> Array<ONGIdentityProvider>
    func submitCustomRegistrationSuccess(_ data: String?)
    func cancelCustomRegistration(_ error: String)
    func currentChallenge() -> ONGCustomRegistrationChallenge?
}

protocol RegistrationHandlerToPinHanlderProtocol: class {
    var pinHandler: PinConnectorToPinHandler? { get set }
}

protocol CustomRegistrationNotificationReceiverProtocol: class {
    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?)
}

class RegistrationHandler: NSObject, BrowserHandlerToRegisterHandlerProtocol, PinHandlerToReceiverProtocol, RegistrationHandlerToPinHanlderProtocol {

    var createPinChallenge: ONGCreatePinChallenge?
    var browserRegistrationChallenge: ONGBrowserRegistrationChallenge?
    var customRegistrationChallenge: ONGCustomRegistrationChallenge?
    var browserConntroller: BrowserHandlerProtocol?
    
    var logoutUserHandler = LogoutHandler()
    var deregisterUserHandler = DeregisterUserHandler()
    var signUpCompletion: ((Result<OWRegistrationResponse, FlutterError>) -> Void)?
    
    unowned var pinHandler: PinConnectorToPinHandler?
    
    unowned var customNotificationReceiver: CustomRegistrationNotificationReceiverProtocol?
    
    //MARK:-
    func currentChallenge() -> ONGCustomRegistrationChallenge? {
        return self.customRegistrationChallenge
    }
    
    func identityProviders() -> Array<ONGIdentityProvider> {
        var list = Array(ONGUserClient.sharedInstance().identityProviders())
        
        let listOutput: [String]? =  OneginiModuleSwift.sharedInstance.customRegIdentifiers.filter { (_id) -> Bool in
            let element = list.first { (provider) -> Bool in
                return provider.identifier == _id
            }
            
            return element == nil
        }
        
        listOutput?.forEach { (_providerId) in
            let identityProvider = ONGIdentityProvider()
            identityProvider.name = _providerId
            identityProvider.identifier = _providerId
            
            list.append(identityProvider)
        }
        
        return list
    }
    
    func presentBrowserUserRegistrationView(registrationUserURL: URL, webSignInType: WebSignInType) {
        guard let browserController = browserConntroller else {
            browserConntroller = BrowserViewController(registerHandlerProtocol: self)
            browserConntroller?.handleUrl(url: registrationUserURL, webSignInType: webSignInType)
            return
        }
        
        browserController.handleUrl(url: registrationUserURL, webSignInType: webSignInType)
    }

    func handleRedirectURL(url: URL?) {
        Logger.log("handleRedirectURL url: \(url?.absoluteString ?? "nil")", sender: self)
        guard let browserRegistrationChallenge = self.browserRegistrationChallenge else {
            //FIXME: Registration not in progress error here
            signUpCompletion?(.failure(FlutterError(.genericError)))
            return
        }
        
        guard let url = url else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
            return
        }
        
        browserRegistrationChallenge.sender.respond(with: url, challenge: browserRegistrationChallenge)
    }

    func handlePin(pin: String?) {
        guard let createPinChallenge = self.createPinChallenge else { return }

        if let _pin = pin {
            createPinChallenge.sender.respond(withCreatedPin: _pin, challenge: createPinChallenge)

        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }

    fileprivate func mapErrorFromPinChallenge(_ challenge: ONGCreatePinChallenge) -> SdkError? {
        if let error = challenge.error {
            return ErrorMapper().mapError(error)
        } else {
            return nil
        }
    }

    private func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?) {
        customNotificationReceiver?.sendCustomRegistrationNotification(event, data)
    }
}

extension RegistrationHandler : RegistrationConnectorToHandlerProtocol {
    func registerUser(_ providerId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        signUpCompletion = completion

        var identityProvider = identityProviders().first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: scopes, delegate: self)
    }
    
    func logout(completion: @escaping (SdkError?) -> Void) {
        logoutUserHandler.logout(completion: completion)
    }
    
    func deregister(profileId: String, completion: @escaping (SdkError?) -> Void) {
        deregisterUserHandler.deregister(profileId: profileId, completion: completion)
    }

    func processRedirectURL(url: String, webSignInType: WebSignInType) {
        guard let url = URL.init(string: url) else {
            signUpCompletion?(.failure(FlutterError(.providedUrlIncorrect)))
            return
        }
        
        if webSignInType != .insideApp && !UIApplication.shared.canOpenURL(url) {
            signUpCompletion?(.failure(FlutterError(.providedUrlIncorrect)))
            return
        }
        
        presentBrowserUserRegistrationView(registrationUserURL: url, webSignInType: webSignInType)
    }
    
    func submitCustomRegistrationSuccess(_ data: String?) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else { return }
        customRegistrationChallenge.sender.respond(withData: data, challenge: customRegistrationChallenge)
    }
    
    func cancelCustomRegistration(_ error: String) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else { return }
        customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
    }

    func cancelBrowserRegistration() {
        handleRedirectURL(url: nil)
    }
}

extension RegistrationHandler: ONGRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        Logger.log("didReceive ONGBrowserRegistrationChallenge", sender:  self)
        browserRegistrationChallenge = challenge
        debugPrint(challenge.url)

        var result = Dictionary<String, Any?>()
        result["eventValue"] = challenge.url.absoluteString

        sendCustomRegistrationNotification(CustomRegistrationNotification.eventHandleRegisteredUrl, result)
    }

    func userClient(_: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        Logger.log("didReceivePinRegistrationChallenge ONGCreatePinChallenge", sender: self)
        createPinChallenge = challenge
        let pinError = mapErrorFromPinChallenge(challenge)
        pinHandler?.handleFlowUpdate(.create, pinError, receiver: self)
    }

    func userClient(_ userClient: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, identityProvider: ONGIdentityProvider, info: ONGCustomInfo?) {
        Logger.log("didRegisterUser", sender: self)
        createPinChallenge = nil
        customRegistrationChallenge = nil
        pinHandler?.closeFlow()

        signUpCompletion?(.success(
            OWRegistrationResponse(userProfile: OWUserProfile(userProfile),
                                   customInfo: toOWCustomInfo(info))))
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationInitChallenge challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationInitChallenge ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge
        
        let result = makeCustomInfoResponse(challenge)
        
        sendCustomRegistrationNotification(CustomRegistrationNotification.initRegistration, result)
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationFinish challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationFinish ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge

        let result = makeCustomInfoResponse(challenge)

        sendCustomRegistrationNotification(CustomRegistrationNotification.finishRegistration, result)
    }

    func userClient(_ userClient: ONGUserClient, didFailToRegisterWith identityProvider: ONGIdentityProvider, error: Error) {
        Logger.log("didFailToRegisterWithError", sender: self)
        createPinChallenge = nil
        customRegistrationChallenge = nil
        pinHandler?.closeFlow()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            signUpCompletion?(.failure(FlutterError(.registrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            signUpCompletion?(.failure(FlutterError(mappedError)))
        }
    }
    
    private func makeCustomInfoResponse(_ challenge: ONGCustomRegistrationChallenge) -> Dictionary<String, Any?> {
        var result = Dictionary<String, Any?>()
        var customInfo = Dictionary<String, Any?>()
        customInfo["status"] = challenge.info?.status
        customInfo["data"] = challenge.info?.data
        customInfo["providerId"] = challenge.identityProvider.identifier
        result["eventValue"] = String.stringify(json: customInfo)

        return result
    }
}
    


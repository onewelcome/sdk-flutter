import OneginiSDKiOS
import OneginiCrypto

protocol RegistrationConnectorToHandlerProtocol: RegistrationHandlerToPinHanlderProtocol {
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, ONGCustomInfo?, SdkError?) -> Void)
    func processRedirectURL(url: String, webSignInType: WebSignInType)
    func cancelRegistration()
    func logout(completion: @escaping (SdkError?) -> Void)
    func deregister(completion: @escaping (SdkError?) -> Void)
    func identityProviders() -> Array<ONGIdentityProvider>
    func processOTPCode(code: String?)
    func cancelCustomRegistration()
    func processTwoStepRegistration(_ data: String)
    func cancelTwoStepRegistration(_ error: String)
    func currentChallenge() -> ONGCustomRegistrationChallenge?
}

protocol RegistrationHandlerToPinHanlderProtocol: class {
    var pinHandler: PinConnectorToPinHandler? { get set }
}

protocol CustomRegistrationNotificationReceiverProtocol: class {
    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?)
}

protocol OtpRegistrationNotificationReceiverProtocol: class {
    func sendCustomOtpNotification(_ event: OneginiBridgeEvents,_ data: Dictionary<String, Any?>?)
}

class RegistrationHandler: NSObject, BrowserHandlerToRegisterHandlerProtocol, PinHandlerToReceiverProtocol, RegistrationHandlerToPinHanlderProtocol {
    
    var middleTwoStep: Bool? = nil
    
    var createPinChallenge: ONGCreatePinChallenge?
    var browserRegistrationChallenge: ONGBrowserRegistrationChallenge?
    var customRegistrationChallenge: ONGCustomRegistrationChallenge?
    var browserConntroller: BrowserHandlerProtocol?
    
    var logoutUserHandler = LogoutHandler()
    var deregisterUserHandler = DisconnectHandler()
    var signUpCompletion: ((Bool, ONGUserProfile?, ONGCustomInfo?, SdkError?) -> Void)?
    //var proccessUrlCompletion: ((Bool, ONGUserProfile?, SdkError?) -> Void)?
    
    unowned var pinHandler: PinConnectorToPinHandler?
    
    unowned var customNotificationReceiver: CustomRegistrationNotificationReceiverProtocol?
    unowned var otpNotificationReceiver: OtpRegistrationNotificationReceiverProtocol?
    
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
            signUpCompletion?(false, nil, nil, SdkError.init(customType: .somethingWentWrong))
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

    func handleOTPCode(_ code: String? = nil, _ cancelled: Bool? = false) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else { return }
        if(cancelled == true) {
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
            return;
        }
        customRegistrationChallenge.sender.respond(withData: code, challenge: customRegistrationChallenge)
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

//MARK:-
extension RegistrationHandler : RegistrationConnectorToHandlerProtocol {
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, ONGCustomInfo?, SdkError?) -> Void) {
//        proccessUrlCompletion = nil
        signUpCompletion = completion

        var identityProvider = identityProviders().first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: ["read"], delegate: self)
    }
    
    func logout(completion: @escaping (SdkError?) -> Void) {
        logoutUserHandler.logout(completion: completion)
    }
    
    func deregister(completion: @escaping (SdkError?) -> Void) {
        deregisterUserHandler.disconnect(completion: completion)
    }

    func processRedirectURL(url: String, webSignInType: WebSignInType) {
        guard let url = URL.init(string: url) else {
            signUpCompletion?(false, nil, nil, SdkError.init(customType: .providedUrlIncorrect))
            return
        }
        
        if webSignInType != .insideApp && !UIApplication.shared.canOpenURL(url) {
            signUpCompletion?(false, nil, nil, SdkError.init(customType: .providedUrlIncorrect))
            return
        }
        
        //proccessUrlCompletion = completion
        //signUpCompletion = nil
        presentBrowserUserRegistrationView(registrationUserURL: url, webSignInType: webSignInType)
    }

    func processOTPCode(code: String?) {
        handleOTPCode(code)
    }

    func cancelCustomRegistration() {
        handleOTPCode(nil, true)
    }
    
    func processTwoStepRegistration(_ data: String) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else { return }
        customRegistrationChallenge.sender.respond(withData: data, challenge: customRegistrationChallenge)
    }
    
    func cancelTwoStepRegistration(_ error: String) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else { return }
        customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
    }

    func cancelRegistration() {
        handleRedirectURL(url: nil)
    }
}

extension RegistrationHandler: ONGRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        Logger.log("didReceive ONGBrowserRegistrationChallenge", sender:  self)
        browserRegistrationChallenge = challenge
        debugPrint(challenge.url)
        //signUpCompletion?(challenge.url.absoluteString, nil)
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

    func userClient(_: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info: ONGCustomInfo?) {
        Logger.log("didRegisterUser", sender: self)
        createPinChallenge = nil
        customRegistrationChallenge = nil
        pinHandler?.closeFlow()
        signUpCompletion?(true, userProfile, info, nil)
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationInitChallenge challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationInitChallenge ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge

        var result = Dictionary<String, Any?>()
        result["eventValue"] = challenge.identityProvider.identifier
        
        middleTwoStep = true
        
        sendCustomRegistrationNotification(CustomRegistrationNotification.initRegistration, result)

        challenge.sender.respond(withData: nil, challenge: challenge)
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationFinish challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationFinish ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge

        var result = Dictionary<String, Any?>()
        result["eventValue"] = challenge.identityProvider.identifier

        var successfulRequest = true
        if let info = challenge.info {
            if (info.status < 2001) {
                var customInfo = Dictionary<String, Any?>()

                customInfo["data"] = info.data
                customInfo["providerId"] = challenge.identityProvider.identifier

                result["eventValue"] = String.stringify(json: customInfo)
            }
            else
            {
                successfulRequest = false
                result["eventValue"] = SdkError.init(errorDescription: mapErrorMessageFromStatus(info.status) ?? "null", code: info.status).toJSON()
            }
        }

        if (successfulRequest) {
            if let _middle = middleTwoStep {
                if (_middle) {
                    sendCustomRegistrationNotification(CustomRegistrationNotification.openCustomTwoStepRegistrationScreen, result)
                    otpNotificationReceiver?.sendCustomOtpNotification(.otpOpen, result)
                    middleTwoStep = false
                    return
                }
            }
            
            sendCustomRegistrationNotification(CustomRegistrationNotification.finishRegistration, result)
            middleTwoStep = nil
        }
        else {
            sendCustomRegistrationNotification(CustomRegistrationNotification.eventError, result)
            otpNotificationReceiver?.sendCustomOtpNotification(.errorNotification, result)
        }
    }

    func userClient(_: ONGUserClient, didFailToRegisterWithError error: Error) {
        Logger.log("didFailToRegisterWithError", sender: self)
        createPinChallenge = nil
        customRegistrationChallenge = nil
        pinHandler?.closeFlow()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            signUpCompletion?(false, nil, nil, SdkError(customType: .registrationCancelled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            signUpCompletion?(false, nil, nil, mappedError)
        }
    }
    
    private func mapErrorMessageFromStatus(_ status: Int) -> String? {
        var errorMessage: String? = nil
        
        if status <= 2000 {
            errorMessage = nil
        } else if status == 4002 {
            errorMessage = "This code is not initialized on portal."
        } else {
            errorMessage = "Provided code is incorrect."
        }
        
        return errorMessage
    }
}
    


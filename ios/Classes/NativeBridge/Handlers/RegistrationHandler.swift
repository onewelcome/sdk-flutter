import OneginiSDKiOS
import OneginiCrypto

protocol RegistrationConnectorToHandlerProtocol: AnyObject {
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void)
    func processRedirectURL(url: URL)
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

class RegistrationHandler: NSObject, BrowserHandlerToRegisterHandlerProtocol, PinHandlerToReceiverProtocol {
    
    var middleTwoStep: Bool? = nil
    
    var createPinChallenge: ONGCreatePinChallenge?
    var browserRegistrationChallenge: ONGBrowserRegistrationChallenge?
    var customRegistrationChallenge: ONGCustomRegistrationChallenge?
    var browserConntroller: BrowserHandlerProtocol?
    
    var logoutUserHandler = LogoutHandler()
    var deregisterUserHandler = DisconnectHandler()
    var signUpCompletion: ((Bool, ONGUserProfile?, SdkError?) -> Void)?
    
    //MARK:-
    func currentChallenge() -> ONGCustomRegistrationChallenge? {
        return self.customRegistrationChallenge
    }
    
    func identityProviders() -> Array<ONGIdentityProvider> {
        var list = Array(ONGUserClient.sharedInstance().identityProviders())
        
        if let _providerId =  OneginiModuleSwift.sharedInstance.customIdentifier, list.filter({$0.identifier == _providerId}).count == 0  {
            
            let identityProvider = ONGIdentityProvider()
            identityProvider.name = _providerId
            identityProvider.identifier = _providerId
            
            list.append(identityProvider)
        }
        
        return list
    }
    
    func presentBrowserUserRegistrationView(registrationUserURL: URL) {
        if(browserConntroller != nil) {
            browserConntroller?.handleUrl(url: registrationUserURL)
        } else {
            if #available(iOS 12.0, *) {
                browserConntroller = BrowserViewController(registerHandlerProtocol: self)
                browserConntroller?.handleUrl(url: registrationUserURL)
            } else {
              // Fallback on earlier versions
            }
        }
    }

    func handleRedirectURL(url: URL?) {
        guard let browserRegistrationChallenge = self.browserRegistrationChallenge else { return }
        if(url != nil) {
            browserRegistrationChallenge.sender.respond(with: url!, challenge: browserRegistrationChallenge)
        } else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
        }
    }

    func handlePin(pin: String?) {
        guard let createPinChallenge = self.createPinChallenge else { return }

        if(pin != nil) {
            createPinChallenge.sender.respond(withCreatedPin: pin!, challenge: createPinChallenge)

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
        BridgeConnector.shared?.toRegistrationConnector.sendCustomRegistrationNotification(event, data);
    }
}

//MARK:-
extension RegistrationHandler : RegistrationConnectorToHandlerProtocol {
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void) {
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

    func processRedirectURL(url: URL) {
        handleRedirectURL(url: url)
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
        browserRegistrationChallenge = challenge
        presentBrowserUserRegistrationView(registrationUserURL: challenge.url)
    }

    func userClient(_: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        createPinChallenge = challenge
        let pinError = mapErrorFromPinChallenge(challenge)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.create, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info _: ONGCustomInfo?) {
        createPinChallenge = nil
        customRegistrationChallenge = nil
        signUpCompletion!(true, userProfile, nil)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationInitChallenge challenge: ONGCustomRegistrationChallenge) {
        customRegistrationChallenge = challenge

        var result = Dictionary<String, Any?>()
        result["eventValue"] = challenge.identityProvider.identifier
        
        middleTwoStep = true
        
        sendCustomRegistrationNotification(CustomRegistrationNotification.initRegistration, result)

        challenge.sender.respond(withData: nil, challenge: challenge)
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationFinish challenge: ONGCustomRegistrationChallenge) {
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
                result["eventValue"] = mapErrorMessageFromStatus(info.status)
            }
        }
        

        if (successfulRequest) {
            if let _middle = middleTwoStep {
                if (_middle) {
                    sendCustomRegistrationNotification(CustomRegistrationNotification.openCustomTwoStepRegistrationScreen, result)
                    BridgeConnector.shared?.toRegistrationConnector.sendCustomOtpNotification(OneginiBridgeEvents.otpOpen, result)
                    
                    middleTwoStep = false
                    return
                }
            }
            
            sendCustomRegistrationNotification(CustomRegistrationNotification.finishRegistration, result)
            middleTwoStep = nil
        }
        else {
            sendCustomRegistrationNotification(CustomRegistrationNotification.eventError, result)
            BridgeConnector.shared?.toRegistrationConnector.sendCustomOtpNotification(OneginiBridgeEvents.errorNotification, result)
        }
    }

    func userClient(_: ONGUserClient, didFailToRegisterWithError error: Error) {
        createPinChallenge = nil
        customRegistrationChallenge = nil
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            signUpCompletion!(false, nil, SdkError(customType: .registrationCancelled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            signUpCompletion!(false, nil, mappedError)
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
    


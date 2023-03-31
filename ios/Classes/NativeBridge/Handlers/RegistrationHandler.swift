import OneginiSDKiOS

enum WebSignInType: Int {
    case insideApp
    case safari

    init(rawValue: Int) {
        switch rawValue {
        case 1: self = .safari
        default: self = .insideApp
        }
    }
}

class RegistrationHandler: NSObject, BrowserHandlerToRegisterHandlerProtocol {

    var createPinChallenge: ONGCreatePinChallenge?
    var browserRegistrationChallenge: ONGBrowserRegistrationChallenge?
    var customRegistrationChallenge: ONGCustomRegistrationChallenge?
    var browserConntroller: BrowserHandlerProtocol?

    var signUpCompletion: ((Result<OWRegistrationResponse, FlutterError>) -> Void)?

    // Should not be needed
    func currentChallenge() -> ONGCustomRegistrationChallenge? {
        return self.customRegistrationChallenge
    }

    // FIXME: why do we need this?
    func identityProviders() -> [ONGIdentityProvider] {
        var list = Array(ONGUserClient.sharedInstance().identityProviders())

        let listOutput: [String]? =  OneginiModuleSwift.sharedInstance.customRegIdentifiers.filter { (providerId) -> Bool in
            let element = list.first { (provider) -> Bool in
                return provider.identifier == providerId
            }

            return element == nil
        }

        listOutput?.forEach { (providerId) in
            let identityProvider = ONGIdentityProvider()
            identityProvider.name = providerId
            identityProvider.identifier = providerId

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
            // FIXME: Registration not in progress error here
            signUpCompletion?(.failure(FlutterError(.genericError)))
            return
        }

        guard let url = url else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
            return
        }

        browserRegistrationChallenge.sender.respond(with: url, challenge: browserRegistrationChallenge)
    }

    func handlePin(pin: String, completion: (Result<Void, FlutterError>) -> Void) {
        guard let createPinChallenge = createPinChallenge else {
            completion(.failure(FlutterError(.registrationNotInProgress)))
            return
        }
        createPinChallenge.sender.respond(withCreatedPin: pin, challenge: createPinChallenge)
        completion(.success)
    }

    func cancelPinRegistration(completion: (Result<Void, FlutterError>) -> Void) {
        guard let createPinChallenge = self.createPinChallenge else {
            completion(.failure(FlutterError(.registrationNotInProgress)))
            return
        }
        createPinChallenge.sender.cancel(createPinChallenge)
        completion(.success)
    }

    func handleDidReceivePinRegistrationChallenge(_ challenge: ONGCreatePinChallenge) {
        createPinChallenge = challenge
        if let pinError = mapErrorFromPinChallenge(challenge) {
            SwiftOneginiPlugin.flutterApi?.n2fEventPinNotAllowed(error: OWOneginiError(code: Int64(pinError.code), message: pinError.errorDescription)) {}
        } else {
            // FIXME: we should be sending the pin length here.
            SwiftOneginiPlugin.flutterApi?.n2fOpenPinRequestScreen {}
        }
    }

    func handleDidFailToRegister() {
        if createPinChallenge == nil && customRegistrationChallenge == nil && browserRegistrationChallenge == nil {
            return
        }
        createPinChallenge = nil
        customRegistrationChallenge = nil
        browserRegistrationChallenge = nil
        SwiftOneginiPlugin.flutterApi?.n2fClosePin {}
    }

    func handleDidRegisterUser() {
        createPinChallenge = nil
        customRegistrationChallenge = nil
        browserRegistrationChallenge = nil
        SwiftOneginiPlugin.flutterApi?.n2fClosePin {}
    }
}

extension RegistrationHandler {
    func registerUser(_ providerId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        signUpCompletion = completion

        var identityProvider = identityProviders().first(where: { $0.identifier == providerId})
        if let providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = providerId
            identityProvider?.identifier = providerId
        }

        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: scopes, delegate: self)
    }

    func processRedirectURL(url: String, webSignInType: Int) -> Result<Void, FlutterError> {
        let webSignInType = WebSignInType(rawValue: webSignInType)
        guard let url = URL.init(string: url) else {
            // FIXME: This doesn't seem right, we're canceling the whole registration here???
            signUpCompletion?(.failure(FlutterError(.providedUrlIncorrect)))
            return .failure(FlutterError(.providedUrlIncorrect))
        }

        if webSignInType != .insideApp && !UIApplication.shared.canOpenURL(url) {
            signUpCompletion?(.failure(FlutterError(.providedUrlIncorrect)))
            return .failure(FlutterError(.providedUrlIncorrect))
        }

        presentBrowserUserRegistrationView(registrationUserURL: url, webSignInType: webSignInType)
        return .success
    }

    func submitCustomRegistrationSuccess(_ data: String?, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else {
            completion(.failure(SdkError(OneWelcomeWrapperError.registrationNotInProgress).flutterError()))
            return
        }
        customRegistrationChallenge.sender.respond(withData: data, challenge: customRegistrationChallenge)
        completion(.success)
    }

    func cancelCustomRegistration(_ error: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let customRegistrationChallenge = self.customRegistrationChallenge else {
            completion(.failure(SdkError(OneWelcomeWrapperError.registrationNotInProgress).flutterError()))
            return
        }
        customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
        completion(.success)
    }

    func cancelBrowserRegistration(_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let browserRegistrationChallenge = self.browserRegistrationChallenge else {
            completion(.failure(FlutterError(.browserRegistrationNotInProgress)))
            return
        }
        browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
    }
}

extension RegistrationHandler: ONGRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        Logger.log("didReceive ONGBrowserRegistrationChallenge", sender: self)
        browserRegistrationChallenge = challenge
        debugPrint(challenge.url)

        SwiftOneginiPlugin.flutterApi?.n2fHandleRegisteredUrl(url: challenge.url.absoluteString) {}
    }

    func userClient(_: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        Logger.log("didReceivePinRegistrationChallenge ONGCreatePinChallenge", sender: self)
        handleDidReceivePinRegistrationChallenge(challenge)
    }

    func userClient(_ userClient: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, identityProvider: ONGIdentityProvider, info: ONGCustomInfo?) {
        handleDidRegisterUser()
        signUpCompletion?(.success(
            OWRegistrationResponse(userProfile: OWUserProfile(userProfile),
                                   customInfo: toOWCustomInfo(info))))
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationInitChallenge challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationInitChallenge ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge
        SwiftOneginiPlugin.flutterApi?.n2fEventInitCustomRegistration(customInfo: toOWCustomInfo(challenge.info), providerId: challenge.identityProvider.identifier) {}
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationFinish challenge: ONGCustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationFinish ONGCustomRegistrationChallenge", sender: self)
        customRegistrationChallenge = challenge
        SwiftOneginiPlugin.flutterApi?.n2fEventFinishCustomRegistration(customInfo: toOWCustomInfo(challenge.info), providerId: challenge.identityProvider.identifier) {}
    }

    func userClient(_ userClient: ONGUserClient, didFailToRegisterWith identityProvider: ONGIdentityProvider, error: Error) {
        handleDidFailToRegister()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            signUpCompletion?(.failure(FlutterError(.registrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            signUpCompletion?(.failure(FlutterError(mappedError)))
        }
    }
}

private func mapErrorFromPinChallenge(_ challenge: ONGCreatePinChallenge) -> SdkError? {
    if let error = challenge.error {
        return ErrorMapper().mapError(error)
    } else {
        return nil
    }
}

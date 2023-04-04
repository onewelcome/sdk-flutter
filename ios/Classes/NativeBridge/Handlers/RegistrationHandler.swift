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

    var createPinChallenge: CreatePinChallenge?
    var browserRegistrationChallenge: BrowserRegistrationChallenge?
    var customRegistrationChallenge: CustomRegistrationChallenge?
    var browserConntroller: BrowserHandlerProtocol?

    func presentBrowserUserRegistrationView(registrationUserURL: URL, webSignInType: WebSignInType) {
        guard let browserController = browserConntroller else {
            browserConntroller = BrowserViewController(registerHandlerProtocol: self)
            browserConntroller?.handleUrl(url: registrationUserURL, webSignInType: webSignInType)
            return
        }

        browserController.handleUrl(url: registrationUserURL, webSignInType: webSignInType)
    }

    func handleRedirectURL(url: URL) {
        Logger.log("handleRedirectURL url: \(url.absoluteString)", sender: self)
        // FIXME: browserRegistrationChallenge is only set to nil when we finish or fail registration, so this will work but will need a refactor if the internal browser ever gets removed.
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            return
        }
        browserRegistrationChallenge.sender.respond(with: url, to: browserRegistrationChallenge)
    }

    func handleCancelFromBrowser() {
        // FIXME: browserRegistrationChallenge is only set to nil when we finish or fail registration, so this will work but will need a refactor if the internal browser ever gets removed.
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            return
        }
        browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
    }

    func handlePin(pin: String, completion: (Result<Void, FlutterError>) -> Void) {
        guard let createPinChallenge = createPinChallenge else {
            completion(.failure(FlutterError(.registrationNotInProgress)))
            return
        }
        createPinChallenge.sender.respond(with: pin, to: createPinChallenge)
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

    func handleDidReceivePinRegistrationChallenge(_ challenge: CreatePinChallenge) {
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

    func registerUser(_ providerId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        let identityProvider = SharedUserClient.instance.identityProviders.first(where: { $0.identifier == providerId})
        let delegate = RegistrationDelegateImpl(registrationHandler: self, completion: completion)
        SharedUserClient.instance.registerUserWith(identityProvider: identityProvider, scopes: scopes, delegate: delegate)
    }

    func processRedirectURL(url: String, webSignInType: Int) -> Result<Void, FlutterError> {
        let webSignInType = WebSignInType(rawValue: webSignInType)
        guard let url = URL.init(string: url) else {
            return .failure(FlutterError(.providedUrlIncorrect))
        }

        if webSignInType != .insideApp && !UIApplication.shared.canOpenURL(url) {
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
        customRegistrationChallenge.sender.respond(with: data, to: customRegistrationChallenge)
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

class RegistrationDelegateImpl: RegistrationDelegate {
    private let completion: ((Result<OWRegistrationResponse, FlutterError>) -> Void)
    private let registrationHandler: RegistrationHandler

    init(registrationHandler: RegistrationHandler, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        self.completion = completion
        self.registrationHandler = registrationHandler
    }

    func userClient(_ userClient: UserClient, didReceiveCreatePinChallenge challenge: CreatePinChallenge) {
        Logger.log("didReceivePinRegistrationChallenge ONGCreatePinChallenge", sender: self)
        registrationHandler.handleDidReceivePinRegistrationChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didReceiveBrowserRegistrationChallenge challenge: BrowserRegistrationChallenge) {
        Logger.log("didReceive ONGBrowserRegistrationChallenge", sender: self)
        registrationHandler.browserRegistrationChallenge = challenge
        debugPrint(challenge.url)

        SwiftOneginiPlugin.flutterApi?.n2fHandleRegisteredUrl(url: challenge.url.absoluteString) {}
    }

    func userClient(_ userClient: UserClient, didReceiveCustomRegistrationInitChallenge challenge: CustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationInitChallenge ONGCustomRegistrationChallenge", sender: self)
        registrationHandler.customRegistrationChallenge = challenge
        SwiftOneginiPlugin.flutterApi?.n2fEventInitCustomRegistration(customInfo: toOWCustomInfo(challenge.info), providerId: challenge.identityProvider.identifier) {}
    }

    func userClient(_ userClient: UserClient, didReceiveCustomRegistrationFinishChallenge challenge: CustomRegistrationChallenge) {
        Logger.log("didReceiveCustomRegistrationFinish ONGCustomRegistrationChallenge", sender: self)
        registrationHandler.customRegistrationChallenge = challenge
        SwiftOneginiPlugin.flutterApi?.n2fEventFinishCustomRegistration(customInfo: toOWCustomInfo(challenge.info), providerId: challenge.identityProvider.identifier) {}
    }

    func userClientDidStartRegistration(_ userClient: UserClient) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didRegisterUser profile: UserProfile, with identityProvider: IdentityProvider, info: CustomInfo?) {
        registrationHandler.handleDidRegisterUser()
        completion(.success(
            OWRegistrationResponse(userProfile: OWUserProfile(profile),
                                   customInfo: toOWCustomInfo(info))))
    }

    func userClient(_ userClient: UserClient, didFailToRegisterUserWith identityProvider: IdentityProvider, error: Error) {
        registrationHandler.handleDidFailToRegister()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            completion(.failure(FlutterError(.registrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            completion(.failure(FlutterError(mappedError)))
        }
    }
}

private func mapErrorFromPinChallenge(_ challenge: CreatePinChallenge) -> SdkError? {
    if let error = challenge.error {
        return ErrorMapper().mapError(error)
    } else {
        return nil
    }
}

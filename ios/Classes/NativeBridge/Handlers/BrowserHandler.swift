import AuthenticationServices
import OneginiSDKiOS
import OneginiCrypto

protocol BrowserHandlerProtocol {
    func handleUrl(url: URL, webSignInType: WebSignInType)
}

protocol BrowserHandlerToRegisterHandlerProtocol: AnyObject {
    func handleRedirectURL(url: URL?)
}

//MARK: - BrowserHandlerProtocol
@available(iOS 12.0, *)
class BrowserViewController: NSObject, BrowserHandlerProtocol {
    var webAuthSession: ASWebAuthenticationSession?

    let registerHandler: BrowserHandlerToRegisterHandlerProtocol

    init(registerHandlerProtocol: BrowserHandlerToRegisterHandlerProtocol) {
        self.registerHandler = registerHandlerProtocol
    }

    func handleUrl(url: URL, webSignInType: WebSignInType) {
        Logger.log("handleUrl url: \(url.absoluteString)", sender: self)
        switch webSignInType {
        case .safari:
            openExternalBrowser(url: url)
        default:
            openInternalBrowser(url: url)
        }

        
    }
    
    private func openExternalBrowser(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            Logger.log("can't open external browser url: \(url.absoluteString)", logType: .error)
            self.cancelButtonPressed()
            return
        }
        UIApplication.shared.open(url, options: [:]) { (value) in
            Logger.log("opened external browser url: \(value)")
        }
    }
    
    private func openInternalBrowser(url: URL) {
        let scheme = URL(string: ONGClient.sharedInstance().configModel.redirectURL)!.scheme
        webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme, completionHandler: { callbackURL, error in
            Logger.log("webAuthSession completionHandler", sender: self)
            guard error == nil, let successURL = callbackURL else {
                self.cancelButtonPressed()
                return;
            }

            self.handleSuccessUrl(url: successURL)
        })

        if #available(iOS 13.0, *) {
            webAuthSession?.prefersEphemeralWebBrowserSession = true
            webAuthSession?.presentationContextProvider = self;
        }
        webAuthSession?.start()
    }

    private func handleSuccessUrl(url: URL) {
        Logger.log("handleSuccessUrl url: \(url)", sender: self)
        registerHandler.handleRedirectURL(url: url)
    }

    private func cancelButtonPressed() {
        Logger.log("cancelButtonPressed", sender: self)
        registerHandler.handleRedirectURL(url: nil)
    }

}

//MARK: - ASWebAuthenticationPresentationContextProviding
@available(iOS 12.0, *)
extension BrowserViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        Logger.log("presentationAnchor for session", sender: self)
        var anchor: ASPresentationAnchor?;
        let group = DispatchGroup()
        group.enter()

        DispatchQueue.global(qos: .default).async {
            anchor = UIApplication.shared.keyWindow!
            group.leave()
        }

        // wait ...
        group.wait()

        return anchor!
    }
}

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
        print("[\(type(of: self))] handleUrl url: \(url)")
        switch webSignInType {
        case .safari:
            openExternalBrowser(url: url)
        default:
            openInternalBrowser(url: url)
        }

        
    }
    
    private func openExternalBrowser(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            self.cancelButtonPressed()
            return
        }
        UIApplication.shared.open(url, options: [:]) { (value) in
            debugPrint("Opened external browser: \(value)")
        }
    }
    
    private func openInternalBrowser(url: URL) {
        let scheme = URL(string: ONGClient.sharedInstance().configModel.redirectURL)!.scheme
        webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme, completionHandler: { callbackURL, error in
            print("[\(type(of: self))] webAuthSession completionHandler")
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
        print("[\(type(of: self))] handleSuccessUrl url: \(url)")
        registerHandler.handleRedirectURL(url: url)
    }

    private func cancelButtonPressed() {
        print("[\(type(of: self))] cancelButtonPressed")
        registerHandler.handleRedirectURL(url: nil)
    }

}

//MARK: - ASWebAuthenticationPresentationContextProviding
@available(iOS 12.0, *)
extension BrowserViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        print("[\(type(of: self))] presentationAnchor for session")
        
        let anchor: ASPresentationAnchor = UIApplication.shared.keyWindow ?? ASPresentationAnchor()
        return anchor
    }
}

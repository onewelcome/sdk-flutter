import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    public func otpResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
        
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleOTPMobileAuth(code ?? "", customRegistrationChallenge: bridgeConnector.toRegistrationConnector.registrationHandler.currentChallenge()) {
            (_ , error) -> Void in

            error != nil ? callback(error?.flutterError()) : callback(nil)
        }
    }
    
    public func otpQRResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
            
        guard bridgeConnector.toMobileAuthConnector.mobileAuthHandler.isUserEnrolledForMobileAuth() else {
            ONGUserClient.sharedInstance().enroll { [weak self] (value, error) in
                
                if let _error = error {
                    callback(SdkError(code: _error.code, errorDescription: _error.localizedDescription).flutterError())
                    return
                }
                
                self?.handleQRCode(code, callback: callback)
            }
            return
        }
        
        handleQRCode(code, callback: callback)
    }
    
    private func handleQRCode(_ code: String?, callback: @escaping FlutterResult) {
        let challenge = bridgeConnector.toRegistrationConnector.registrationHandler.currentChallenge()
        var handleMobileAuthConfirmation = false
        
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleQrOTPMobileAuth(code ?? "", customRegistrationChallenge: challenge) { [weak self]
            (value, error) -> Void in
            
            if(error == nil && !handleMobileAuthConfirmation) {
                handleMobileAuthConfirmation = true
                self?.bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleMobileAuthConfirmation(cancelled: true)
            } else {
                error != nil ? callback(error?.flutterError()) : callback(value)
            }
        }
    }
    
    func acceptMobileAuthConfirmation() -> Void {
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleMobileAuthConfirmation(cancelled: false)
    }

    @objc
    func denyMobileAuthConfirmation() -> Void {
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleMobileAuthConfirmation(cancelled: true)
    }
}

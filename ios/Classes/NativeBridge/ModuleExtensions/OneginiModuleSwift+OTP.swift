import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    public func handleMobileAuthWithOtp2(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toMobileAuthHandler.handleMobileAuthWithOtp2(otp: otp, completion: completion)
    }
    
    public func enrollMobileAuthentication() -> Void) {
        bridgeConnector.toMobileAuthHandler.handleMobileAuthWithOtp2(otp: otp, completion: completion)
    }
    
    
    // fixme isnt getting used?
    public func otpResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
        
        // FIXME: Check what's going on here, why is custom registration challange put in mobile auth
        bridgeConnector.toMobileAuthHandler.handleOTPMobileAuth(code ?? "", customRegistrationChallenge: bridgeConnector.toRegistrationHandler.currentChallenge()) {
            (_ , error) -> Void in

            error != nil ? callback(error?.flutterError()) : callback(nil)
        }
    }
    
    // this is handleMobileAuthWithOtp
    public func otpQRResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
        // remove logic for isuserenrolled
        guard bridgeConnector.toMobileAuthHandler.isUserEnrolledForMobileAuth() else {
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
    
    // this is handleMobileAuthWithOtp 2
    private func handleQRCode(_ code: String?, callback: @escaping FlutterResult) {
        // FIXME: Check what's going on here, why is custom registration challange put in mobile auth
        let challenge = bridgeConnector.toRegistrationHandler.currentChallenge()
        var handleMobileAuthConfirmation = false
        
        bridgeConnector.toMobileAuthHandler.handleQrOTPMobileAuth(code ?? "", customRegistrationChallenge: challenge) { [weak self]
            (value, error) -> Void in
            
            if(error == nil && !handleMobileAuthConfirmation) {
                // if correct this case???
                handleMobileAuthConfirmation = true
                self?.bridgeConnector.toMobileAuthHandler.handleMobileAuthConfirmation(cancelled: true)
            } else {
                error != nil ? callback(error?.flutterError()) : callback(value)
            }
        }
    }
    
    func acceptMobileAuthConfirmation() -> Void {
        bridgeConnector.toMobileAuthHandler.handleMobileAuthConfirmation(cancelled: false)
    }

    @objc
    func denyMobileAuthConfirmation() -> Void {
        bridgeConnector.toMobileAuthHandler.handleMobileAuthConfirmation(cancelled: true)
    }
}

import Foundation
import OneginiSDKiOS
import OneginiCrypto
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
                    callback(SdkError.init(errorDescription: _error.localizedDescription, code: _error.code).flutterError())
                    return
                }
                
                self?.handleQRCode(code, callback: callback)
            }
            return
        }
        
        handleQRCode(code, callback: callback)
    }
    
    private func handleQRCode(_ code: String?, callback: @escaping FlutterResult) {
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleQrOTPMobileAuth(code ?? "", customRegistrationChallenge: bridgeConnector.toRegistrationConnector.registrationHandler.currentChallenge()) {
            (_ , error) -> Void in

            error != nil ? callback(error?.flutterError()) : callback(nil)
        }
    }
    
    func acceptMobileAuthConfirmation(callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleMobileAuthConfirmation(cancelled: false)
    }

    @objc
    func denyMobileAuthConfirmation(callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleMobileAuthConfirmation(cancelled: true)
    }
}

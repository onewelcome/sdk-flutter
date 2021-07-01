import Foundation
import OneginiSDKiOS
import Flutter

protocol OTPConnectorProtocol {
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func handleQRCode(_ code: String, callback: @escaping FlutterResult) -> Void
}

class OTPConnector: OTPConnectorProtocol {
    private(set) var otpWrapper: OTPWrapperProtocol
    private(set) var enrollAuthWrapper: EnrollMobileAuthWrapperProtocol
    
    init(wrapper: OTPWrapperProtocol = OTPWrapper.init(), enrollAuthWrapper: EnrollMobileAuthWrapperProtocol = EnrollMobileAuthWrapper()) {
        self.otpWrapper = wrapper
        self.enrollAuthWrapper = enrollAuthWrapper
    }
    
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("handleMobileAuthWithOtp", sender: self)
        guard let arguments = call.arguments as? [String: Any],
              let code = arguments[Constants.Parameters.data] as? String else {
            result(FlutterError.from(customType: .invalidArguments))
            return
        }
        
        let userProfile = self.enrollAuthWrapper.authenticatedUserProfile()
        guard !self.enrollAuthWrapper.isUserEnrolledForMobileAuth(profile: userProfile) else {
            
            handleQRCode(code, callback: result)
            return
        }
        
        self.enrollAuthWrapper.enroll { [weak self] (success, error) in
            guard let error = error else {
                self?.handleQRCode(code, callback: result)
                return
            }
            result(FlutterError.from(error: error))
        }
    }
    
    func handleQRCode(_ code: String, callback: @escaping FlutterResult) {
        var handleMobileAuthConfirmation = false
        //TODO: currentChallenge
        let challenge: ONGCustomRegistrationChallenge? = nil //bridgeConnector.toRegistrationConnector.registrationHandler.currentChallenge()
        
        guard self.otpWrapper.canHandleOTP(code) else {
            callback(FlutterError.from(customType: .cantHandleOTP))
            return
        }
        
        self.otpWrapper.handleQrOTPMobileAuth(code, customRegistrationChallenge: challenge) { [weak self] (value, error) in
            guard let weakSelf = self else {
                return
            }
            
            if(error == nil && !handleMobileAuthConfirmation) {
                handleMobileAuthConfirmation = true
                weakSelf.otpWrapper.handleMobileAuthConfirmation(cancelled: true)
            } else {
                error != nil ? callback(FlutterError.from(error: error!)) : callback(value)
            }
        }
    }
    
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("acceptOtpAuthenticationRequest", sender: self)
        self.otpWrapper.handleMobileAuthConfirmation(cancelled: false)
    }
    
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("denyOtpAuthenticationRequest", sender: self)
        self.otpWrapper.handleMobileAuthConfirmation(cancelled: true)
    }
}

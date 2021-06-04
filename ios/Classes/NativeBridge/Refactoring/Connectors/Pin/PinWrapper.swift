import Foundation
import OneginiSDKiOS

typealias PinChangeCallbackSuccess = (Bool, Error?) -> Void

protocol PinWrapperProtocol {
    var changePinCompletion: PinChangeCallbackSuccess? { get set}
    func changePin(completion: @escaping PinChangeCallbackSuccess)
}

class PinWrapper: NSObject, PinWrapperProtocol {
    var pinChallenge: ONGPinChallenge?
    var createPinChallenge: ONGCreatePinChallenge?
    var changePinCompletion: PinChangeCallbackSuccess?
    
    func changePin(completion: @escaping PinChangeCallbackSuccess) {
        changePinCompletion = completion
        ONGUserClient.sharedInstance().changePin(self)
    }
}

extension PinWrapper: ONGChangePinDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        Logger.log("didReceive ONGPinChallenge", sender: self)
        pinChallenge = challenge
        //let pinError = FlutterError.fromPinChallenge(challenge)
        
        if challenge.containsAuthenticationAttemptIssue() {
            //TODO: nextAuthenticationAttempt
            return
        }
        //TODO: authentication
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        Logger.log("didReceive ONGCreatePinChallenge", sender: self)
        pinChallenge = nil
        //TODO: closeFlow()
        createPinChallenge = challenge
        //TODO: create
    }

    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        Logger.log("didFailToChangePinForUser", sender: self)
        pinChallenge = nil
        createPinChallenge = nil
        //TODO: closeFlow()

        changePinCompletion?(false, error)
        changePinCompletion = nil
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        Logger.log("didChangePinForUser", sender: self)
        createPinChallenge = nil
        //TODO: closeFlow()
        changePinCompletion?(true, nil)
        changePinCompletion = nil
    }
}

extension ONGPinChallenge {
    func containsAuthenticationAttemptIssue() -> Bool {
        guard let error = self.error,
           error.code == ONGAuthenticationError.invalidPin.rawValue,
           previousFailureCount < maxFailureCount else {
            return false
        }
        return true
    }
}

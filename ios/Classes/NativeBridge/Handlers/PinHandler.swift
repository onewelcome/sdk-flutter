import OneginiSDKiOS
import Flutter

protocol PinHandlerToReceiverProtocol: class {
    func handlePin(pin: String?)
}

protocol PinNotificationReceiverProtocol: class {
    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?)
}

enum PINEntryMode {
    case login
    case registration
}

//MARK: -
class PinHandler: NSObject {
    var pinChallenge: ONGPinChallenge?
    var createPinChallenge: ONGCreatePinChallenge?
    var flow: PinFlow?
    var mode: PINEntryMode?
    var pinEntryToVerify = Array<String>()
    var changePinCompletion: ((Bool, SdkError?) -> Void)?
    
    unowned var pinReceiver: PinHandlerToReceiverProtocol?
    unowned var notificationReceiver: PinNotificationReceiverProtocol?

    private func processPin(pinEntry: Array<String>) {
        let pincode = pinEntry.joined()
        switch mode {
          case .login, .registration:
              pinReceiver?.handlePin(pin: pincode)
              break
          case .none:
            pinReceiver?.handlePin(pin: pincode)
              break
        }
    }

    private func processCancelAction() {
        mode = nil
        pinReceiver?.handlePin(pin: nil)
    }

    private func notifyOnError(_ error: SdkError) {
        sendConnectorNotification(PinNotification.showError, flow, error)
    }

    private func notifyNextAuthenticationAttempt(_ error: SdkError) {
        sendConnectorNotification(PinNotification.nextAuthenticationAttempt, flow, error)
    }

    private func sendConnectorNotification(_ event: PinNotification, _ flow: PinFlow?, _ error: SdkError?) {
        notificationReceiver?.sendNotification(event: event, flow: flow, error: error)
    }
}

//MARK: -
extension PinHandler {
    func handleFlowUpdate(_ flow: PinFlow, _ error: SdkError?, receiver: PinHandlerToReceiverProtocol) {
        if(self.flow == nil){
            self.flow = flow
            pinReceiver = receiver
        }

        if let _error = error {
            if flow == .nextAuthenticationAttempt {
                notifyNextAuthenticationAttempt(_error)
            } else {
                notifyOnError(_error)
            }
        } else {
            if(mode == nil) {
                var notification = PinNotification.open;
                
                switch flow {
                    case PinFlow.authentication:
                        mode = .login
                        notification = PinNotification.openAuth;
                        break
                    case PinFlow.create:
                        mode = .registration
                        notification = PinNotification.open;
                        break
                    case PinFlow.nextAuthenticationAttempt:
                        mode = .login
                        notification = PinNotification.nextAuthenticationAttempt;
                        break
                    default:
                        mode = .registration
                        notification = PinNotification.open;
                        break
                }

                sendConnectorNotification(notification, flow, nil)
            }
        }
    }

    func closeFlow() {
        if(flow != nil){
            var closeNotification = PinNotification.close
            if (mode == PINEntryMode.login) {
                closeNotification = PinNotification.closeAuth
            }
            
            mode = nil
            flow = nil
            sendConnectorNotification(closeNotification, flow, nil)
        }
    }

    func onPinProvided(pin: String) {
      let characters: String = pin as String
      let pinArray: Array<String> = Array(arrayLiteral: characters)

      processPin(pinEntry: pinArray)
    }

    func onChangePinCalled(completion: @escaping (Bool, SdkError?) -> Void) {
        changePinCompletion = completion
        ONGUserClient.sharedInstance().changePin(self)
    }

    func onCancel() {
        processCancelAction()
    }
    
    func validatePinWithPolicy(pin: String, completion: @escaping (Result<Void, SdkError>) -> Void) {
        ONGUserClient.sharedInstance().validatePin(withPolicy: pin) { (value, error) in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(SdkError(code: error.code, errorDescription: error.localizedDescription)))
        }
    }
 }

//MARK: -
extension PinHandler : PinHandlerToReceiverProtocol {
    func handlePin(pin: String?) {
        guard let createPinChallenge = self.createPinChallenge else {
            guard let pinChallenge = self.pinChallenge else { return }

            if let _pin = pin {
                pinChallenge.sender.respond(withPin: _pin, challenge: pinChallenge)

            } else {
                pinChallenge.sender.cancel(pinChallenge)
            }

            return
        }

        if let _pin = pin {
            createPinChallenge.sender.respond(withCreatedPin: _pin, challenge: createPinChallenge)

        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }

    fileprivate func mapErrorFromCreatePinChallenge(_ challenge: ONGCreatePinChallenge) -> SdkError? {
        if let error = challenge.error {
            return ErrorMapper().mapError(error)
        } else {
            return nil
        }
    }
}

//MARK: - ONGChangePinDelegate
extension PinHandler: ONGChangePinDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        Logger.log("didReceive ONGPinChallenge", sender: self)
        pinChallenge = challenge
        let pinError = ErrorMapper().mapErrorFromPinChallenge(challenge)
        
        if let error = pinError, error.code == ONGAuthenticationError.invalidPin.rawValue, challenge.previousFailureCount < challenge.maxFailureCount { // 9009
            handleFlowUpdate(PinFlow.nextAuthenticationAttempt, error, receiver: self)
            return
        }
        
        handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        Logger.log("didReceive ONGCreatePinChallenge", sender: self)
        pinChallenge = nil
        closeFlow()
        createPinChallenge = challenge
        let pinError = mapErrorFromCreatePinChallenge(challenge)
        handleFlowUpdate(PinFlow.create, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        Logger.log("didFailToChangePinForUser", sender: self)
        pinChallenge = nil
        createPinChallenge = nil
        closeFlow()

        let mappedError = ErrorMapper().mapError(error)

        if error.code == ONGGenericError.actionCancelled.rawValue {
            changePinCompletion?(false, SdkError(.changingPinCancelled))
        } else if error.code == ONGGenericError.userDeregistered.rawValue {
            changePinCompletion?(false, mappedError)
        } else {
            changePinCompletion?(false, mappedError)
        }
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        Logger.log("didChangePinForUser", sender: self)
        createPinChallenge = nil
        closeFlow()
        changePinCompletion?(true, nil)
    }
}

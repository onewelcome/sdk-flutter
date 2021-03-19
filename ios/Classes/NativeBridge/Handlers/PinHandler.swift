import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol PinConnectorToPinHandler: AnyObject {
    func onPinProvided(pin: String)
    func onChangePinCalled(completion: @escaping (Bool, SdkError?) -> Void)
    func onCancel()
    func handleFlowUpdate(_ flow: PinFlow, _ error: SdkError?, receiver: PinHandlerToReceiverProtocol)
    func closeFlow()
}

protocol PinHandlerToReceiverProtocol: class {
    func handlePin(pin: String?)
}

enum PINEntryMode {
    case login
    case registration
}

class PinHandler: NSObject {
    var pinChallenge: ONGPinChallenge?
    var createPinChallenge: ONGCreatePinChallenge?
    var flow: PinFlow?
    var mode: PINEntryMode?
    var pinEntryToVerify = Array<String>()
    var changePinCompletion: ((Bool, SdkError?) -> Void)?
    unowned var pinReceiver: PinHandlerToReceiverProtocol?

    func processPin(pinEntry: Array<String>) {
        let pincode = pinEntry.joined()
        switch mode {
          case .login, .registration:
              pinReceiver?.handlePin(pin: pincode)
              break
          case .none:
            pinReceiver?.handlePin(pin: pincode)
//              notifyOnError(SdkError(title: "Pin validation error", errorDescription: "Unexpected PIN mode.", recoverySuggestion: "Open and close modal."))
              break
        }
    }

    private func processCancelAction() {
        mode = nil
        pinReceiver?.handlePin(pin: nil)
    }

    func notifyOnError(_ error: SdkError) {
        sendConnectorNotification(PinNotification.showError, flow, error)
    }

    private func sendConnectorNotification(_ event: PinNotification, _ flow: PinFlow?, _ error: SdkError?) {
        BridgeConnector.shared?.toPinHandlerConnector.sendNotification(event: event, flow: flow, error: error)
    }
}

extension PinHandler : PinConnectorToPinHandler {
    
    // @todo Support different pinLength
    func handleFlowUpdate(_ flow: PinFlow, _ error: SdkError?, receiver: PinHandlerToReceiverProtocol) {
        if(self.flow == nil){
            self.flow = flow
            pinReceiver = receiver
        }

        if(error != nil){
            notifyOnError(error!)
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
 }

extension PinHandler : PinHandlerToReceiverProtocol {
    func handlePin(pin: String?) {
        guard let createPinChallenge = self.createPinChallenge else {
            guard let pinChallenge = self.pinChallenge else { return }

            if(pin != nil) {
                pinChallenge.sender.respond(withPin: pin!, challenge: pinChallenge)

            } else {
                pinChallenge.sender.cancel(pinChallenge)
            }

            return
        }

        if(pin != nil) {
            createPinChallenge.sender.respond(withCreatedPin: pin!, challenge: createPinChallenge)

        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }

    fileprivate func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge) -> SdkError? {
        if let error = challenge.error {
            return ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            return nil
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

extension PinHandler: ONGChangePinDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        pinChallenge = challenge
        let pinError = mapErrorFromPinChallenge(challenge)
        handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        pinChallenge = nil
        closeFlow()
        createPinChallenge = challenge
        let pinError = mapErrorFromCreatePinChallenge(challenge)
        handleFlowUpdate(PinFlow.create, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        pinChallenge = nil
        createPinChallenge = nil
        closeFlow()

        let mappedError = ErrorMapper().mapError(error)

        if error.code == ONGGenericError.actionCancelled.rawValue {
            changePinCompletion!(false, SdkError(customType: .changingCancelled))
        } else if error.code == ONGGenericError.userDeregistered.rawValue {
            changePinCompletion!(false, mappedError)
        } else {
            changePinCompletion!(false, mappedError)
        }
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        createPinChallenge = nil
        closeFlow()
        changePinCompletion!(true, nil)
    }
}

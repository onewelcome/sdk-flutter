// Autogenerated from Pigeon (v9.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif



private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

/// Result objects
///
/// Generated class from Pigeon that represents data sent in messages.
struct OWUserProfile {
  var profileId: String

  static func fromList(_ list: [Any?]) -> OWUserProfile? {
    let profileId = list[0] as! String

    return OWUserProfile(
      profileId: profileId
    )
  }
  func toList() -> [Any?] {
    return [
      profileId,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OWCustomInfo {
  var status: Int32
  var data: String

  static func fromList(_ list: [Any?]) -> OWCustomInfo? {
    let status = list[0] as! Int32
    let data = list[1] as! String

    return OWCustomInfo(
      status: status,
      data: data
    )
  }
  func toList() -> [Any?] {
    return [
      status,
      data,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OWIdentityProvider {
  var id: String
  var name: String

  static func fromList(_ list: [Any?]) -> OWIdentityProvider? {
    let id = list[0] as! String
    let name = list[1] as! String

    return OWIdentityProvider(
      id: id,
      name: name
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      name,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OWAuthenticator {
  var id: String
  var name: String
  var isRegistered: Bool
  var isPreferred: Bool
  var authenticatorType: Int32

  static func fromList(_ list: [Any?]) -> OWAuthenticator? {
    let id = list[0] as! String
    let name = list[1] as! String
    let isRegistered = list[2] as! Bool
    let isPreferred = list[3] as! Bool
    let authenticatorType = list[4] as! Int32

    return OWAuthenticator(
      id: id,
      name: name,
      isRegistered: isRegistered,
      isPreferred: isPreferred,
      authenticatorType: authenticatorType
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      name,
      isRegistered,
      isPreferred,
      authenticatorType,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OWAppToWebSingleSignOn {
  var token: String
  var redirectUrl: String

  static func fromList(_ list: [Any?]) -> OWAppToWebSingleSignOn? {
    let token = list[0] as! String
    let redirectUrl = list[1] as! String

    return OWAppToWebSingleSignOn(
      token: token,
      redirectUrl: redirectUrl
    )
  }
  func toList() -> [Any?] {
    return [
      token,
      redirectUrl,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OWRegistrationResponse {
  var userProfile: OWUserProfile
  var customInfo: OWCustomInfo? = nil

  static func fromList(_ list: [Any?]) -> OWRegistrationResponse? {
    let userProfile = OWUserProfile.fromList(list[0] as! [Any?])!
    var customInfo: OWCustomInfo? = nil
    if let customInfoList = list[1] as? [Any?] {
      customInfo = OWCustomInfo.fromList(customInfoList)
    }

    return OWRegistrationResponse(
      userProfile: userProfile,
      customInfo: customInfo
    )
  }
  func toList() -> [Any?] {
    return [
      userProfile.toList(),
      customInfo?.toList(),
    ]
  }
}

private class UserClientApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return OWAppToWebSingleSignOn.fromList(self.readValue() as! [Any])
      case 129:
        return OWAuthenticator.fromList(self.readValue() as! [Any])
      case 130:
        return OWCustomInfo.fromList(self.readValue() as! [Any])
      case 131:
        return OWIdentityProvider.fromList(self.readValue() as! [Any])
      case 132:
        return OWRegistrationResponse.fromList(self.readValue() as! [Any])
      case 133:
        return OWUserProfile.fromList(self.readValue() as! [Any])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class UserClientApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? OWAppToWebSingleSignOn {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? OWAuthenticator {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? OWCustomInfo {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? OWIdentityProvider {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else if let value = value as? OWRegistrationResponse {
      super.writeByte(132)
      super.writeValue(value.toList())
    } else if let value = value as? OWUserProfile {
      super.writeByte(133)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class UserClientApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return UserClientApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return UserClientApiCodecWriter(data: data)
  }
}

class UserClientApiCodec: FlutterStandardMessageCodec {
  static let shared = UserClientApiCodec(readerWriter: UserClientApiCodecReaderWriter())
}

/// Flutter calls native
///
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol UserClientApi {
  func fetchUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void)
  func registerUser(identityProviderId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void)
  func handleRegisteredUserUrl(url: String, signInType: Int32, completion: @escaping (Result<Void, Error>) -> Void)
  func getIdentityProviders(completion: @escaping (Result<[OWIdentityProvider], Error>) -> Void)
  func deregisterUser(profileId: String, completion: @escaping (Result<Void, Error>) -> Void)
  func getRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void)
  func getAllAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void)
  func getAuthenticatedUserProfile(completion: @escaping (Result<OWUserProfile, Error>) -> Void)
  func authenticateUser(profileId: String, registeredAuthenticatorId: String?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void)
  func getNotRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void)
  func changePin(completion: @escaping (Result<Void, Error>) -> Void)
  func setPreferredAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void)
  func deregisterAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void)
  func registerAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void)
  func logout(completion: @escaping (Result<Void, Error>) -> Void)
  func mobileAuthWithOtp(data: String, completion: @escaping (Result<String?, Error>) -> Void)
  func getAppToWebSingleSignOn(url: String, completion: @escaping (Result<OWAppToWebSingleSignOn, Error>) -> Void)
  func getAccessToken(completion: @escaping (Result<String, Error>) -> Void)
  func getRedirectUrl(completion: @escaping (Result<String, Error>) -> Void)
  func getUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void)
  func validatePinWithPolicy(pin: String, completion: @escaping (Result<Void, Error>) -> Void)
  func authenticateDevice(scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void)
  func authenticateUserImplicitly(profileId: String, scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class UserClientApiSetup {
  /// The codec used by UserClientApi.
  static var codec: FlutterStandardMessageCodec { UserClientApiCodec.shared }
  /// Sets up an instance of `UserClientApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: UserClientApi?) {
    let fetchUserProfilesChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.fetchUserProfiles", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      fetchUserProfilesChannel.setMessageHandler { _, reply in
        api.fetchUserProfiles() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      fetchUserProfilesChannel.setMessageHandler(nil)
    }
    let registerUserChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.registerUser", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      registerUserChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let identityProviderIdArg = args[0] as? String
        let scopesArg = args[1] as? [String]
        api.registerUser(identityProviderId: identityProviderIdArg, scopes: scopesArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      registerUserChannel.setMessageHandler(nil)
    }
    let handleRegisteredUserUrlChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.handleRegisteredUserUrl", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      handleRegisteredUserUrlChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let urlArg = args[0] as! String
        let signInTypeArg = args[1] as! Int32
        api.handleRegisteredUserUrl(url: urlArg, signInType: signInTypeArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      handleRegisteredUserUrlChannel.setMessageHandler(nil)
    }
    let getIdentityProvidersChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getIdentityProviders", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getIdentityProvidersChannel.setMessageHandler { _, reply in
        api.getIdentityProviders() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getIdentityProvidersChannel.setMessageHandler(nil)
    }
    let deregisterUserChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.deregisterUser", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      deregisterUserChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        api.deregisterUser(profileId: profileIdArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      deregisterUserChannel.setMessageHandler(nil)
    }
    let getRegisteredAuthenticatorsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getRegisteredAuthenticators", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getRegisteredAuthenticatorsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        api.getRegisteredAuthenticators(profileId: profileIdArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getRegisteredAuthenticatorsChannel.setMessageHandler(nil)
    }
    let getAllAuthenticatorsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getAllAuthenticators", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getAllAuthenticatorsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        api.getAllAuthenticators(profileId: profileIdArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getAllAuthenticatorsChannel.setMessageHandler(nil)
    }
    let getAuthenticatedUserProfileChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getAuthenticatedUserProfile", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getAuthenticatedUserProfileChannel.setMessageHandler { _, reply in
        api.getAuthenticatedUserProfile() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getAuthenticatedUserProfileChannel.setMessageHandler(nil)
    }
    let authenticateUserChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.authenticateUser", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      authenticateUserChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        let registeredAuthenticatorIdArg = args[1] as? String
        api.authenticateUser(profileId: profileIdArg, registeredAuthenticatorId: registeredAuthenticatorIdArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      authenticateUserChannel.setMessageHandler(nil)
    }
    let getNotRegisteredAuthenticatorsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getNotRegisteredAuthenticators", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getNotRegisteredAuthenticatorsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        api.getNotRegisteredAuthenticators(profileId: profileIdArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getNotRegisteredAuthenticatorsChannel.setMessageHandler(nil)
    }
    let changePinChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.changePin", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      changePinChannel.setMessageHandler { _, reply in
        api.changePin() { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      changePinChannel.setMessageHandler(nil)
    }
    let setPreferredAuthenticatorChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.setPreferredAuthenticator", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      setPreferredAuthenticatorChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let authenticatorIdArg = args[0] as! String
        api.setPreferredAuthenticator(authenticatorId: authenticatorIdArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      setPreferredAuthenticatorChannel.setMessageHandler(nil)
    }
    let deregisterAuthenticatorChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.deregisterAuthenticator", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      deregisterAuthenticatorChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let authenticatorIdArg = args[0] as! String
        api.deregisterAuthenticator(authenticatorId: authenticatorIdArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      deregisterAuthenticatorChannel.setMessageHandler(nil)
    }
    let registerAuthenticatorChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.registerAuthenticator", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      registerAuthenticatorChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let authenticatorIdArg = args[0] as! String
        api.registerAuthenticator(authenticatorId: authenticatorIdArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      registerAuthenticatorChannel.setMessageHandler(nil)
    }
    let logoutChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.logout", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      logoutChannel.setMessageHandler { _, reply in
        api.logout() { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      logoutChannel.setMessageHandler(nil)
    }
    let mobileAuthWithOtpChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.mobileAuthWithOtp", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      mobileAuthWithOtpChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let dataArg = args[0] as! String
        api.mobileAuthWithOtp(data: dataArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      mobileAuthWithOtpChannel.setMessageHandler(nil)
    }
    let getAppToWebSingleSignOnChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getAppToWebSingleSignOn", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getAppToWebSingleSignOnChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let urlArg = args[0] as! String
        api.getAppToWebSingleSignOn(url: urlArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getAppToWebSingleSignOnChannel.setMessageHandler(nil)
    }
    let getAccessTokenChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getAccessToken", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getAccessTokenChannel.setMessageHandler { _, reply in
        api.getAccessToken() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getAccessTokenChannel.setMessageHandler(nil)
    }
    let getRedirectUrlChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getRedirectUrl", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getRedirectUrlChannel.setMessageHandler { _, reply in
        api.getRedirectUrl() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getRedirectUrlChannel.setMessageHandler(nil)
    }
    let getUserProfilesChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.getUserProfiles", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getUserProfilesChannel.setMessageHandler { _, reply in
        api.getUserProfiles() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getUserProfilesChannel.setMessageHandler(nil)
    }
    let validatePinWithPolicyChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.validatePinWithPolicy", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      validatePinWithPolicyChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let pinArg = args[0] as! String
        api.validatePinWithPolicy(pin: pinArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      validatePinWithPolicyChannel.setMessageHandler(nil)
    }
    let authenticateDeviceChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.authenticateDevice", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      authenticateDeviceChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let scopesArg = args[0] as? [String]
        api.authenticateDevice(scopes: scopesArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      authenticateDeviceChannel.setMessageHandler(nil)
    }
    let authenticateUserImplicitlyChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.UserClientApi.authenticateUserImplicitly", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      authenticateUserImplicitlyChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let profileIdArg = args[0] as! String
        let scopesArg = args[1] as? [String]
        api.authenticateUserImplicitly(profileId: profileIdArg, scopes: scopesArg) { result in
          switch result {
            case .success:
              reply(wrapResult(nil))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      authenticateUserImplicitlyChannel.setMessageHandler(nil)
    }
  }
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol ResourceMethodApi {
  func getResourceAnonymous(completion: @escaping (Result<String?, Error>) -> Void)
  func getResource(completion: @escaping (Result<String?, Error>) -> Void)
  func getResourceImplicit(completion: @escaping (Result<String?, Error>) -> Void)
  func getUnauthenticatedResource(completion: @escaping (Result<String?, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class ResourceMethodApiSetup {
  /// The codec used by ResourceMethodApi.
  /// Sets up an instance of `ResourceMethodApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ResourceMethodApi?) {
    let getResourceAnonymousChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ResourceMethodApi.getResourceAnonymous", binaryMessenger: binaryMessenger)
    if let api = api {
      getResourceAnonymousChannel.setMessageHandler { _, reply in
        api.getResourceAnonymous() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getResourceAnonymousChannel.setMessageHandler(nil)
    }
    let getResourceChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ResourceMethodApi.getResource", binaryMessenger: binaryMessenger)
    if let api = api {
      getResourceChannel.setMessageHandler { _, reply in
        api.getResource() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getResourceChannel.setMessageHandler(nil)
    }
    let getResourceImplicitChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ResourceMethodApi.getResourceImplicit", binaryMessenger: binaryMessenger)
    if let api = api {
      getResourceImplicitChannel.setMessageHandler { _, reply in
        api.getResourceImplicit() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getResourceImplicitChannel.setMessageHandler(nil)
    }
    let getUnauthenticatedResourceChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.ResourceMethodApi.getUnauthenticatedResource", binaryMessenger: binaryMessenger)
    if let api = api {
      getUnauthenticatedResourceChannel.setMessageHandler { _, reply in
        api.getUnauthenticatedResource() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getUnauthenticatedResourceChannel.setMessageHandler(nil)
    }
  }
}
/// Native calls to Flutter
///
/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class NativeCallFlutterApi {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger){
    self.binaryMessenger = binaryMessenger
  }
  func testEventFunction(argument argumentArg: String, completion: @escaping (String) -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.NativeCallFlutterApi.testEventFunction", binaryMessenger: binaryMessenger)
    channel.sendMessage([argumentArg] as [Any?]) { response in
      let result = response as! String
      completion(result)
    }
  }
}
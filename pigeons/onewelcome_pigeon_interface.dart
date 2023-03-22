import 'package:pigeon/pigeon.dart';

// @ConfigurePigeon(PigeonOptions(
//   dartOut: './../lib/pigeon.dart',
//   kotlinOut: 'android/src/main/kotlin/com/zero/flutter_pigeon_plugin/Pigeon.kt',
//   kotlinOptions: KotlinOptions(
//    // copyrightHeader: ['zero'],
//     package: 'com.zero.flutter_pigeon_plugin',
//   ),
//   objcHeaderOut: 'ios/Runner/Pigeon.h',
//   objcSourceOut: 'ios/Runner/Pigeon.m',
//   objcOptions: ObjcOptions(
//     prefix: 'FLT',
//   ),
// ))

/// Result objects
class OWUserProfile {
  String profileId;

  OWUserProfile({required this.profileId});
}

class OWCustomInfo {
  int status;
  String? data;

  OWCustomInfo({required this.status, required this.data});
}

class OWIdentityProvider {
  String id;
  String name;

  OWIdentityProvider({required this.id, required this.name});
}

class OWAuthenticator {
  String id;
  String name;
  bool isRegistered;
  bool isPreferred;
  int authenticatorType;

  OWAuthenticator(
      {required this.id,
      required this.name,
      required this.isRegistered,
      required this.isPreferred,
      required this.authenticatorType});
}

class OWAppToWebSingleSignOn {
  String token;
  String redirectUrl;

  OWAppToWebSingleSignOn({required this.token, required this.redirectUrl});
}

class OWRegistrationResponse {
  OWUserProfile userProfile;
  OWCustomInfo? customInfo;

  OWRegistrationResponse({required this.userProfile, this.customInfo});
}

enum HttpRequestMethod {
  get,
  post,
  put,
  delete,
}

enum ResourceRequestType { authenticated, implicit, anonymous, unauthenticated }

class OWRequestDetails {
  String path;
  HttpRequestMethod method;
  Map<String?, String?>? headers;
  String? body;

  OWRequestDetails({required this.path, required this.method, headers, body});
}

class OWRequestResponse {
  Map<String?, String?> headers;
  String body;
  bool ok;
  int status;

  OWRequestResponse(
      {required this.headers,
      required this.body,
      required this.ok,
      required this.status});
}

class OWAuthenticationAttempt {
  int failedAttempts;
  int maxAttempts;
  int remainingAttempts;
  OWAuthenticationAttempt(
      {required this.failedAttempts,
      required this.maxAttempts,
      required this.remainingAttempts});
}

class OWOneginiError {
  int code;
  String message;
  OWOneginiError({required this.code, required this.message});
}

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  @async
  OWRegistrationResponse registerUser(
      String? identityProviderId, List<String>? scopes);

  @async
  void handleRegisteredUserUrl(String url, int signInType);

  @async
  List<OWIdentityProvider> getIdentityProviders();

  @async
  void deregisterUser(String profileId);

  @async
  List<OWAuthenticator> getRegisteredAuthenticators(String profileId);

  @async
  List<OWAuthenticator> getAllAuthenticators(String profileId);

  @async
  OWUserProfile getAuthenticatedUserProfile();

  @async
  OWRegistrationResponse authenticateUser(
      String profileId, String? registeredAuthenticatorId);

  @async
  List<OWAuthenticator> getNotRegisteredAuthenticators(String profileId);

  @async
  void changePin();

  @async
  void setPreferredAuthenticator(String authenticatorId);

  @async
  void deregisterAuthenticator(String authenticatorId);

  @async
  void registerAuthenticator(String authenticatorId);

  @async
  void logout();

  // todo investigate if string can be non null
  @async
  String? mobileAuthWithOtp(String data);

  @async
  OWAppToWebSingleSignOn getAppToWebSingleSignOn(String url);

  @async
  String getAccessToken();

  @async
  String getRedirectUrl();

  @async
  List<OWUserProfile> getUserProfiles();

  @async
  void validatePinWithPolicy(String pin);

  @async
  void authenticateDevice(List<String>? scopes);

  @async
  void authenticateUserImplicitly(String profileId, List<String>? scopes);

  /// Custom Registration Callbacks
  @async
  void submitCustomRegistrationAction(String identityProviderId, String? data);

  @async
  void cancelCustomRegistrationAction(String identityProviderId, String error);

  /// Fingerprint Callbacks
  @async
  void fingerprintFallbackToPin();

  @async
  void fingerprintDenyAuthenticationRequest();

  @async
  void fingerprintAcceptAuthenticationRequest();

  /// OTP Callbacks
  @async
  void otpDenyAuthenticationRequest();

  @async
  void otpAcceptAuthenticationRequest();

  /// Pin Authentication Callbacks
  @async
  void pinDenyAuthenticationRequest();

  @async
  void pinAcceptAuthenticationRequest(String pin);

  /// Pin Registration Callbacks
  @async
  void pinDenyRegistrationRequest();

  @async
  void pinAcceptRegistrationRequest(String pin);

  /// Browser Registration Callbacks
  @async
  void cancelBrowserRegistration();
}

@HostApi()
abstract class ResourceMethodApi {
  @async
  OWRequestResponse requestResource(
      ResourceRequestType type, OWRequestDetails details);
}

/// Native calls to Flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  ///Called to handle registration URL
  void n2fHandleRegisteredUrl(String url);

  /// Called to open OTP authentication.
  void n2fOpenAuthOtp(String message);

  /// Called to close OTP authentication.
  void n2fCloseAuthOtp();

  /// Called to open pin registration screen.
  void n2fOpenPinRequestScreen();

  /// Called to open pin authentication screen.
  void n2fOpenPinScreenAuth();

  /// Called to open pin authentication screen.
  void n2fOpenPinAuthenticator();

  /// Called to attempt next authentication.
  void n2fNextAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt);

  /// Called to close pin registration screen.
  void n2fClosePin();

  /// Called to close pin authentication screen.
  void n2fClosePinAuth();

  /// Called to open fingerprint screen.
  void n2fOpenFingerprintScreen();

  /// Called to scan fingerprint.
  void n2fShowScanningFingerprint();

  /// Called when fingerprint was received.
  void n2fReceivedFingerprint();

  /// Called to close fingerprint screen.
  void n2fCloseFingerprintScreen();

  /// Called when the InitCustomRegistration event occurs and a response should be given (only for two-step)
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId);

  /// Called when the FinishCustomRegistration event occurs and a response should be given
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId);

  /// Called when error event was received.
  void n2fEventError(OWOneginiError error);

  /// Called whenever error occured.
  void n2fShowError(OWOneginiError error);
}

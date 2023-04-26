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
  OWAuthenticatorType authenticatorType;

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

enum OWAuthenticatorType {
  pin,
  biometric,
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

class OWCustomIdentityProvider {
  String providerId;
  bool isTwoStep;
  OWCustomIdentityProvider(this.providerId, this.isTwoStep);
}

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  @async
  void startApplication(
      String? securityControllerClassName,
      String? configModelClassName,
      List<OWCustomIdentityProvider>? customIdentityProviderConfigs,
      int? connectionTimeout,
      int? readTimeout,
      List<String>? additionalResourceUrls);

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
  OWUserProfile getAuthenticatedUserProfile();

  @async
  OWRegistrationResponse authenticateUser(
      String profileId, OWAuthenticatorType authenticatorType);

  // This api is currently required because pigeon does not allow nullable enums
  // as arguments. This is a workaround for that so we still have the nullable
  // enum in the user_client api.
  @async
  OWRegistrationResponse authenticateUserPreferred(String profileId);

  @async
  OWAuthenticator getBiometricAuthenticator(String profileId);

  @async
  OWAuthenticator getPreferredAuthenticator(String profileId);

  @async
  void setPreferredAuthenticator(OWAuthenticatorType authenticatorType);

  @async
  void deregisterBiometricAuthenticator();

  @async
  void registerBiometricAuthenticator();

  @async
  void changePin();

  @async
  void logout();

  @async
  void enrollMobileAuthentication();

  @async
  void handleMobileAuthWithOtp(String data);

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
  void submitCustomRegistrationAction(String? data);

  @async
  void cancelCustomRegistrationAction(String error);

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
  // Browser Registration
  ///Called to handle registration URL
  void n2fHandleRegisteredUrl(String url);

  // Pin Creation
  /// Called to open pin creation screen.
  void n2fOpenPinCreation();

  /// Called to close pin registration screen.
  void n2fClosePinCreation();

  /// Called to indicate that the given pin is not allowed for pin creation
  void n2fPinNotAllowed(OWOneginiError error);

  // Pin Authentication
  /// Called to open pin authentication screen.
  void n2fOpenPinAuthentication();

  /// Called to close pin authentication screen.
  void n2fClosePinAuthentication();

  /// Called to attempt next pin authentication.
  void n2fNextPinAuthenticationAttempt(
      OWAuthenticationAttempt authenticationAttempt);

  // OTP Mobile Authentication
  /// Called to open OTP authentication.
  void n2fOpenAuthOtp(String? message);

  /// Called to close OTP authentication.
  void n2fCloseAuthOtp();

  // Fingerprint Authentication
  /// Called to open fingerprint screen.
  void n2fOpenFingerprintScreen();

  /// Called to close fingerprint screen.
  void n2fCloseFingerprintScreen();

  /// Called to scan fingerprint.
  void n2fShowScanningFingerprint();

  /// Called when fingerprint was received.
  void n2fNextFingerprintAuthenticationAttempt();

  // Custom Registration
  /// Called when the InitCustomRegistration event occurs and a response should be given (only for two-step)
  void n2fEventInitCustomRegistration(
      OWCustomInfo? customInfo, String providerId);

  /// Called when the FinishCustomRegistration event occurs and a response should be given
  void n2fEventFinishCustomRegistration(
      OWCustomInfo? customInfo, String providerId);
}

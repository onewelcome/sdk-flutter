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

  OWAuthenticator({required this.id, required this.name});
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

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  // example function
  @async
  List<OWUserProfile> fetchUserProfiles();

  @async
  OWRegistrationResponse registerUser(String? identityProviderId, List<String>? scopes);

  @async
  void handleRegisteredUserUrl(String url, int signInType);

  @async
  List<OWIdentityProvider> getIdentityProviders();

  // removed boolean return
  @async
  void deregisterUser(String profileId);

  @async
  List<OWAuthenticator> getRegisteredAuthenticators(String profileId);

  @async
  List<OWAuthenticator> getAllAuthenticators(String profileId);

  @async
  OWUserProfile getAuthenticatedUserProfile();

  @async
  OWRegistrationResponse authenticateUser(String profileId, String? registeredAuthenticatorId);

  @async
  List<OWAuthenticator> getNotRegisteredAuthenticators(String profileId);

  @async
  void changePin();

  // changed it into void instead of boolean
  @async
  void setPreferredAuthenticator(String authenticatorId);

  // changed it into void instead of boolean
  @async
  void deregisterAuthenticator(String authenticatorId);

  @async
  void registerAuthenticator(String authenticatorId);

  // changed it into void instead of boolean
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

  // todo update return value to object
  @async
  void authenticateUserImplicitly(String profileId, List<String>? scopes);

  @async
  void submitCustomRegistrationAction(String identityProviderId, String? data);

  @async
  void cancelCustomRegistrationAction(String identityProviderId, String error);
}

@HostApi()
abstract class ResourceMethodApi {
  @async
  String? getResourceAnonymous();

  @async
  String? getResource();

  @async
  String? getResourceImplicit();

  @async
  String? getUnauthenticatedResource();
}

/// Native calls to Flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  @async
  String testEventFunction(String argument);
}

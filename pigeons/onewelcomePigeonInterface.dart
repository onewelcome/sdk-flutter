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
class OneWelcomeUserProfile {
  String profileId;
  bool isDefault;

  OneWelcomeUserProfile({required this.profileId, required this.isDefault});
}

class OneWelcomeCustomInfo {
  int status;
  String data;

  OneWelcomeCustomInfo({required this.status, required this.data});
}

class OneWelcomeIdentityProvider {
  String id;
  String name;

  OneWelcomeIdentityProvider({required this.id, required this.name});
}

class OneWelcomeAuthenticator {
  String id;
  String name;

  OneWelcomeAuthenticator({required this.id, required this.name});
}

class OneWelcomeAppToWebSingleSignOn {
  String token;
  String redirectUrl;

  OneWelcomeAppToWebSingleSignOn({required this.token, required this.redirectUrl});
}

class OneWelcomeRegistrationResponse {
  OneWelcomeUserProfile userProfile;
  OneWelcomeCustomInfo? customInfo;

  OneWelcomeRegistrationResponse({required this.userProfile, this.customInfo});
}

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  // example one
  @async
  List<OneWelcomeUserProfile> fetchUserProfiles();

  @async
  void voidFunction();

  @async
  String? nullableStringFunction();
  // // todo removed buildcontext
  // @async
  // OneWelcomeRegistrationResponse registerUser(String? identityProviderId, List<String>? scopes);

  // @async
  // void handleRegisteredUserUrl(String? url, int signInType);

  // // todo removed buildcontext
  // @async
  // List<OneWelcomeIdentityProvider> getIdentityProviders();

  // // removed boolean return
  // @async
  // void deregisterUser(String profileId);

  // // todo removed buildconext
  // @async
  // List<OneWelcomeAuthenticator> getRegisteredAuthenticators(String profileId);

  // // todo removed buildconext
  // @async
  // List<OneWelcomeAuthenticator> getAllAuthenticators(String profileId);

  // @async
  // OneWelcomeUserProfile getAuthenticatedUserProfile();

  // // todo removed build context
  // @async
  // OneWelcomeRegistrationResponse authenticateUser(String profileId, String? registeredAuthenticatorId);

  // // todo removed context
  // @async
  // List<OneWelcomeAuthenticator> getNotRegisteredAuthenticators(String profileId);

  // // todo removed context
  // @async
  // void changePin();

  // // removed context and changed it into void instead of boolean
  // @async
  // void setPreferredAuthenticator(String authenticatorId);

  // // removed context and changed it into void instead of boolean
  // @async
  // void deregisterAuthenticator(String authenticatorId);

  // // removed context and changed it into void instead of boolean
  // @async
  // void logout();

  // // todo investigate if string can be non null
  // @async
  // String? mobileAuthWithOtp(String data);

  // @async
  // OneWelcomeAppToWebSingleSignOn getAppToWebSingleSignOn(String url);

  // @async
  // String getAccessToken();

  // @async
  // String getRedirectUrl();

  // @async
  // List<OneWelcomeUserProfile> getUserProfiles();

  // @async
  // bool validatePinWithPolicy();

  // @async
  // bool authenticateDevice(List<String>? scopes);

  // // todo update return value to object
  // @async
  // OneWelcomeUserProfile authenticateUserImplicitly(String profileId, List<String>? scopes);
}

@HostApi()
abstract class ResourceMethodApi {
  @async
  List<OneWelcomeUserProfile> fetchUserProfiles();
}

/// Native calls to Flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  @async
  String testEventFunction(String argument);
}

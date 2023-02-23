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

// Error Class
class OneWelcomeNativeError {
  String code;
  String message;
  Map<String?, Object?> details;

  OneWelcomeNativeError(
      {required this.code, required this.message, required this.details});
}

// Return Objects
class UserProfile {
  String profileId;

  UserProfile({required this.profileId});
}

// Results
enum State {
  success,
  error,
}

// class Result {
//   State state;
//   OneWelcomeNativeError? error;

//   Result({required this.state});
// }

class UserProfilesResult {
  State state;
  List<UserProfile?>? success;
  OneWelcomeNativeError? error;

  UserProfilesResult({required this.state});
}

class PigeonUserProfile {
  String profileId;
  bool isDefault;

  PigeonUserProfile({required this.profileId, required this.isDefault});
}

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  @async
  List<PigeonUserProfile> fetchUserProfiles();

  @async
  UserProfilesResult testFunction();
}

/// Native calls Flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  @async
  String testEventFunction(String argument);
}

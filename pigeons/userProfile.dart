import 'package:onegini/model/registration_response.dart';
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
class PigeonUserProfile {
  String profileId;
  bool isDefault;

  PigeonUserProfile({required this.profileId, required this.isDefault});
}

class PigeonCustomInfo {
  int status;
  String data;

  PigeonCustomInfo({required this.status, required this.data});
}

// class PigeonRegistrationResponse

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  // example one
  @async
  List<PigeonUserProfile> fetchUserProfiles();

  // todo removed buildcontext
  RegistrationResponse registerUser(String? identityProviderId, List<String>? scopes);

  
}

@HostApi()
abstract class ResourceMethodApi {
  @async
  List<PigeonUserProfile> fetchUserProfiles();
}

/// Native calls Flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  @async
  String testEventFunction(String argument);
}

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

class PigeonUserProfile {
  String profileId;
  bool isDefault;

  PigeonUserProfile({ required this.profileId, required this.isDefault});
}

/// Flutter calls native
@HostApi()
abstract class UserClientApi {
  @async
  List<PigeonUserProfile> fetchUserProfiles();
}

/// Native calls Flutter
@FlutterApi()
abstract class NativeCallFlutterApi{
  @async
  String testEventFunction(String argument);
}

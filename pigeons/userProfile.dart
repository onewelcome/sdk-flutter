import 'package:pigeon/pigeon.dart';

class PigeonUserProfile {
  String profileId;
  bool isDefault;

  PigeonUserProfile({ required this.profileId, required this.isDefault});
}

@HostApi()
abstract class UserClientApi {
  @async
  List<PigeonUserProfile> fetchUserProfiles();
}
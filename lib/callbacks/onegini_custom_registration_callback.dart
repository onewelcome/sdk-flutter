import 'package:onegini/pigeon.dart';

class OneginiCustomRegistrationCallback {
  final api = UserClientApi();

  Future<void> submitSuccessAction(
      String identityProviderId, String? data) async {
    await api.submitCustomRegistrationAction(identityProviderId, data);
  }

  Future<void> submitErrorAction(
      String identityProviderId, String error) async {
    await api.cancelCustomRegistrationAction(identityProviderId, error);
  }
}

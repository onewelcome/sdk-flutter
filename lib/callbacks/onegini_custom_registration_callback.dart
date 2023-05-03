import 'package:onegini/onegini.gen.dart';

class OneginiCustomRegistrationCallback {
  final api = UserClientApi();

  Future<void> submitSuccessAction(String? data) async {
    await api.submitCustomRegistrationAction(data);
  }

  Future<void> submitErrorAction(String error) async {
    await api.cancelCustomRegistrationAction(error);
  }
}

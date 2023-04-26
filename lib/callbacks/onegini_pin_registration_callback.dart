import 'package:onegini/auto_generated_pigeon.dart';

/// A callback for pin REGISTRATION.
class OneginiPinRegistrationCallback {
  final api = UserClientApi();

  /// Cancels pin registration request.
  Future<void> denyAuthenticationRequest() async {
    await api.pinDenyRegistrationRequest();
  }

  /// Accepts pin registration and sent [pin] to the OneginiSdk.
  Future<void> acceptAuthenticationRequest(String pin) async {
    await api.pinAcceptRegistrationRequest(pin);
  }
}

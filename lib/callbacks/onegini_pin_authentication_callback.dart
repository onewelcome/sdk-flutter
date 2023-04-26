import 'package:onegini/onegini.gen.dart';

/// A callback for pin AUTHENTICATION.
class OneginiPinAuthenticationCallback {
  final api = UserClientApi();

  /// Cancels pin authentication.
  Future<void> denyAuthenticationRequest() async {
    await api.pinDenyAuthenticationRequest();
  }

  /// Accepts pin authentication and sent [pin] to the OneginiSdk.
  Future<void> acceptAuthenticationRequest(String pin) async {
    await api.pinAcceptAuthenticationRequest(pin);
  }
}

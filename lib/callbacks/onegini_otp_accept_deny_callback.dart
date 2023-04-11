import 'package:onegini/pigeon.dart';

/// A callback for mobile authentication with OTP
class OneginiOtpAcceptDenyCallback {
  final api = UserClientApi();

  /// Cancels OTP authentication.
  Future<void> denyAuthenticationRequest() async {
    await api.otpDenyAuthenticationRequest();
  }

  /// Accepts OTP authentication.
  Future<void> acceptAuthenticationRequest() async {
    await api.otpAcceptAuthenticationRequest();
  }
}

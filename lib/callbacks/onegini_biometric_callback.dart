import 'dart:async';
import 'package:onegini/onegini.gen.dart';

/// A callback of biometric authentication.
/// Use this callback when user wants to authenticate by biometric and show biometric prompt.
class OneginiBiometricCallback {
  final api = UserClientApi();

  /// Show biometric prompt.
  Future<void> showBiometricPrompt(String title, String subTitle, String negativeButtonText) async {
    await api.showBiometricPrompt(title, subTitle, negativeButtonText);
  }

  /// Close biometric prompt.
  Future<void> closeBiometricPrompt() async {
    await api.closeBiometricPrompt();
  }

  /// Changes the authentication method from Biometric to PIN.
  Future<void> fallbackToPin() async {
    await api.biometricFallbackToPin();
  }

  /// Cancels authentication request. Used when user cancels authentication by biometric.
  Future<void> denyAuthenticationRequest() async {
    await api.biometricDenyAuthenticationRequest();
  }
}
import 'dart:async';
import 'package:onegini/pigeon.dart';

/// A callback of fingerprint authentication.
///
/// Use this callback when user want authenticate by fingerprint.
class OneginiFingerprintCallback {
  final api = UserClientApi();

  /// Changes the authentication method from fingerprint to PIN.
  Future<void> fallbackToPin() async {
    await api.fingerprintFallbackToPin();
  }

  /// Cancels authentication request.
  ///
  /// Used when a user has canceled a authentication by fingerprint.
  Future<void> denyAuthenticationRequest() async {
    await api.fingerprintDenyAuthenticationRequest();
  }

  /// Accept fingerprint request.
  ///
  /// Use this method when you want start scanning fingerprint.
  Future<void> acceptAuthenticationRequest() async {
    await api.fingerprintAcceptAuthenticationRequest();
  }
}

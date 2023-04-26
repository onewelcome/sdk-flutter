import 'package:onegini/auto_generated_pigeon.dart';

/// A callback for registration.
class OneginiRegistrationCallback {
  final api = UserClientApi();

  /// Cancels registration action.
  Future<void> cancelBrowserRegistration() async {
    await api.cancelBrowserRegistration();
  }
}

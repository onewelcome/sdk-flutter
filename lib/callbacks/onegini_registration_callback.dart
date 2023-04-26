import 'package:onegini/onegini.gen.dart';

/// A callback for registration.
class OneginiRegistrationCallback {
  final api = UserClientApi();

  /// Cancels registration action.
  Future<void> cancelBrowserRegistration() async {
    await api.cancelBrowserRegistration();
  }
}

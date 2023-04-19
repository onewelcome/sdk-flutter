// Wrapper for Fingerprint Events
import 'package:onegini/events/onewelcome_events.dart';

class OpenFingerprintEvent extends OWEvent {
  OpenFingerprintEvent() : super(OWAction.openFingerprint);
}

class CloseFingerprintEvent extends OWEvent {
  CloseFingerprintEvent() : super(OWAction.closeFingerprint);
}

class ShowScanningFingerprintEvent extends OWEvent {
  ShowScanningFingerprintEvent() : super(OWAction.showScanningFingerprint);
}

class NextFingerprintAuthenticationAttempt extends OWEvent {
  NextFingerprintAuthenticationAttempt()
      : super(OWAction.nextFingerprintAuthenticationAttempt);
}

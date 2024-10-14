// Wrapper for Biometric Events
import 'package:onegini/events/onewelcome_events.dart';

class StartBiometricAuthEvent extends OWEvent {
  StartBiometricAuthEvent() : super(OWAction.startBiometric);
}

class FinishBiometricAuthEvent extends OWEvent {
  FinishBiometricAuthEvent() : super(OWAction.finishBiometric);
}
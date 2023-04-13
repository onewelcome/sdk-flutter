// Wrapper for Pin Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/pigeon.dart';

// For Pin Creation
class OpenPinRegistrationEvent extends OWEvent {
  OpenPinRegistrationEvent() : super(OWAction.openPinRegistration);
}

class ClosePinRegistrationEvent extends OWEvent {
  ClosePinRegistrationEvent() : super(OWAction.closePinRegistration);
}

class PinNotAllowedEvent extends OWEvent {
  OWOneginiError error;
  PinNotAllowedEvent(this.error) : super(OWAction.pinNotAllowed);
}

// For Pin Authentication
class OpenPinAuthenticationEvent extends OWEvent {
  OpenPinAuthenticationEvent() : super(OWAction.openPinAuthentication);
}

class ClosePinAuthenticationEvent extends OWEvent {
  ClosePinAuthenticationEvent() : super(OWAction.closePinAuthentication);
}

class NextAuthenticationAttemptEvent extends OWEvent {
  OWAuthenticationAttempt authenticationAttempt;
  NextAuthenticationAttemptEvent(this.authenticationAttempt) : super(OWAction.nextAuthenticationAttempt);
}

// Wrapper for Pin Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini.gen.dart';

// For Pin Creation
class OpenPinCreationEvent extends OWEvent {
  OpenPinCreationEvent() : super(OWAction.openPinCreation);
}

class ClosePinCreationEvent extends OWEvent {
  ClosePinCreationEvent() : super(OWAction.closePinCreation);
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

class NextPinAuthenticationAttemptEvent extends OWEvent {
  OWAuthenticationAttempt authenticationAttempt;
  NextPinAuthenticationAttemptEvent(this.authenticationAttempt)
      : super(OWAction.nextPinAuthenticationAttempt);
}

// Wrapper for Pin Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/pigeon.dart';

class OpenPinRegistrationEvent extends OWEvent {
  OpenPinRegistrationEvent() : super(OWAction.openPinRegistration);
}

class ClosePinRegistrationEvent extends OWEvent {
  ClosePinRegistrationEvent() : super(OWAction.closePinRegistration);
}

class OpenPinAuthenticationEvent extends OWEvent {
  OpenPinAuthenticationEvent() : super(OWAction.openPinAuthentication);
}

class ClosePinAuthenticationEvent extends OWEvent {
  ClosePinAuthenticationEvent() : super(OWAction.closePinAuthentication);
}

class PinNotAllowedEvent extends OWEvent {
  OWOneginiError error;
  PinNotAllowedEvent(this.error) : super(OWAction.pinNotAllowed);
}

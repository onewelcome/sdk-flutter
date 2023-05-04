// Wrapper for OTP Events
import 'package:onegini/events/onewelcome_events.dart';

class OpenAuthOtpEvent extends OWEvent {
  String message;
  OpenAuthOtpEvent(this.message) : super(OWAction.openAuthOtp);
}

class CloseAuthOtpEvent extends OWEvent {
  CloseAuthOtpEvent() : super(OWAction.closeAuthOtp);
}

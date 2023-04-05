// Wrapper for Generic Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/pigeon.dart';

class NextAuthenticationAttemptEvent extends OWEvent {
  OWAuthenticationAttempt authenticationAttempt;
  NextAuthenticationAttemptEvent(this.authenticationAttempt) : super(OWAction.nextAuthenticationAttempt);
}

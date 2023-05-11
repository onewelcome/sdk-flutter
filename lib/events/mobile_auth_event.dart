// Wrapper for OTP Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini.gen.dart';

class StartMobileAuthWithPushEvent extends OWEvent {
  OWMobileAuthRequest request;
  StartMobileAuthWithPushEvent(this.request) : super(OWAction.startPushAuth);
}

class FinishMobileAuthWithPushEvent extends OWEvent {
  FinishMobileAuthWithPushEvent() : super(OWAction.finishPushAuth);
}

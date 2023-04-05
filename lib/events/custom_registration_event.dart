// Wrapper for Custom Registration Events
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/pigeon.dart';

class InitCustomRegistrationEvent extends OWEvent {
  OWCustomInfo? customInfo;
  String providerId;
  InitCustomRegistrationEvent(this.customInfo, this.providerId) : super(OWAction.initCustomRegistration);
}

class FinishCustomRegistrationEvent extends OWEvent {
  OWCustomInfo? customInfo;
  String providerId;
  FinishCustomRegistrationEvent(this.customInfo, this.providerId) : super(OWAction.finishCustomRegistration);
}

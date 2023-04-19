// Wrapper for Browser Events
import 'package:onegini/events/onewelcome_events.dart';

class HandleRegisteredUrlEvent extends OWEvent {
  String url;
  HandleRegisteredUrlEvent(this.url) : super(OWAction.handleRegisteredUrl);
}

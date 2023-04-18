import 'dart:async';

import 'package:onegini/events/browser_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/user_client.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';

// Event Subscriptions related to the creation of Pin
class BrowserRegistrationSubscriptions {
  static List<StreamSubscription<OWEvent>> initSubscriptions() {
    return [_getHandleRegisteredUrSub()];
  }

  static StreamSubscription<OWEvent> _getHandleRegisteredUrSub() {
    return OWBroadcastHelper.createStream<HandleRegisteredUrlEvent>().listen((event) {
      Onegini.instance.userClient.handleRegisteredUserUrl(event.url,
        signInType: WebSignInType.insideApp);
    });
  }
}
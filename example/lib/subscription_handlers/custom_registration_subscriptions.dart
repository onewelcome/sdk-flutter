import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_custom_registration_callback.dart';
import 'package:onegini/events/custom_registration_event.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini_example/components/display_toast.dart';
import 'package:onegini_example/ow_broadcast_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:onegini_example/screens/otp_screen.dart';

// Event Subscriptions related to Custom Registration
class CustomRegistrationSubscriptions {
  static List<StreamSubscription<OWEvent>> getSubscriptions(BuildContext context) {
    return [_getInitCustomRegistrationSub(), _getFinishCustomRegistrationSub(context)];
  }

  static StreamSubscription<OWEvent> _getInitCustomRegistrationSub() {
    return OWBroadcastHelper.createStream<InitCustomRegistrationEvent>().listen((event) {
      if (event.providerId == "2-way-otp-api") {
        // a 2-way-otp does not require data for the initialization request
        OneginiCustomRegistrationCallback()
            .submitSuccessAction(event.providerId, null)
            .catchError((error) => {
              if (error is PlatformException)
                {showFlutterToast(error.message ?? "An error occuring while answering init custom registration")}
            });
      }
    });
  }

  static StreamSubscription<OWEvent> _getFinishCustomRegistrationSub(BuildContext context) {
    return OWBroadcastHelper.createStream<FinishCustomRegistrationEvent>().listen((event) {
      if (event.providerId == "2-way-otp-api") {
        // a 2-way-otp does not require data for the initialization request
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                  password: event.customInfo?.data, providerId: event.providerId)),
        );
      }
    });
  }
}

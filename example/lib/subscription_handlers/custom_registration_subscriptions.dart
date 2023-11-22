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
List<StreamSubscription<OWEvent>> initCustomRegistrationSubscriptions(
    BuildContext context) {
  return [
    _getInitCustomRegistrationSub(),
    _getFinishCustomRegistrationSub(context)
  ];
}

StreamSubscription<OWEvent> _getInitCustomRegistrationSub() {
  return OWBroadcastHelper.createStream<InitCustomRegistrationEvent>()
      .listen((event) {
    if (event.providerId == "2-way-otp-api") {
      // a 2-way-otp does not require data for the initialization request
      OneginiCustomRegistrationCallback()
          .submitSuccessAction(null)
          .catchError((error) => {
                if (error is PlatformException)
                  {
                    showFlutterToast(error.message ??
                        "An error occuring while answering init custom registration")
                  }
              });
    }
    if (event.providerId == "New2step") {
      // a New2step requires data for the initialization request
      OneginiCustomRegistrationCallback()
          .submitSuccessAction("12345")
          .catchError((error) => {
                if (error is PlatformException)
                  {
                    showFlutterToast(error.message ??
                        "An error occuring while answering init custom registration")
                  }
              });
    }
  });
}

StreamSubscription<OWEvent> _getFinishCustomRegistrationSub(
    BuildContext context) {
  return OWBroadcastHelper.createStream<FinishCustomRegistrationEvent>()
      .listen((event) {
    if (event.providerId == "2-way-otp-api" || event.providerId == "New2step") {
      // a 2-way-otp does not require data for the initialization request
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpScreen(
                password: event.customInfo?.data ?? "",
                providerId: event.providerId)),
      );
    }
    if (event.providerId == "qr_registration") {
      // This identity provider is set up to accept a body with 'Onegini'
      // Normally this would contain some single use token.
      OneginiCustomRegistrationCallback().submitSuccessAction('Onegini');
    }
    if (event.providerId == "stateless-test") {
      OneginiCustomRegistrationCallback().submitSuccessAction('success');
    }
  });
}

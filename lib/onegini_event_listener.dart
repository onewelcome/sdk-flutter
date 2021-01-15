import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';
import 'model/authentication_attempt.dart';
import 'model/onegini_event.dart';

abstract class OneginiEventListener {
  static const chanel_name = 'onegini_events';
  static const EventChannel _eventChannel = const EventChannel(chanel_name);

  BuildContext _context;

  set context(BuildContext context) {
    _context = context;
  }

  void listen() {
    _eventChannel.receiveBroadcastStream(chanel_name).listen((event) {
      if (event == Constants.eventOpenPin) {
        openPinScreen(_context);
      } else if(event == Constants.eventOpenPinAuth){
        openPinScreenAuth(_context);
      } else if (event == Constants.eventOpenPinConfirmation) {
        openPinConfirmation(_context);
      } else if (event == Constants.eventClosePin) {
        closePin(_context);
      } else if (event != null) {
        Event _event = eventFromJson(event);
        if(_event.eventName == Constants.eventNextAuthenticationAttempt){
          nextAuthenticationAttempt(_context,authenticationAttemptFromJson(_event.eventValue));
        } else {
          eventOther(_context, _event);
        }
      }
    }).onError((error) {
      eventError(_context, error);
    });
  }

  void openPinScreen(BuildContext buildContext);

  void openPinScreenAuth(BuildContext buildContext);

  void openPinConfirmation(BuildContext buildContext);

  void nextAuthenticationAttempt(BuildContext buildContext,AuthenticationAttempt authenticationAttempt);

  void closePin(BuildContext buildContext);

  void eventError(BuildContext buildContext,PlatformException error);

  void eventOther(BuildContext buildContext, Event event);

}

import 'package:flutter/services.dart';
import 'package:onegini/constants/constants.dart';

import '../onegini.dart';

/// A callback to respond to the init and finish of customRegistrationActions.
class OneginiCustomRegistrationCallback {
    Future<void> submitSuccessAction(String identityProviderId, String? token) async {
        await Onegini.instance.channel.invokeMethod(
            Constants.submitCustomRegistrationSuccessAction,
            <String, dynamic>{
                'identityProviderId': identityProviderId,
                'token': token
            }
        );
    }

    Future<void> submitErrorAction(String identityProviderId, String error) async {
        await Onegini.instance.channel.invokeMethod(
            Constants.submitCustomRegistrationErrorAction,
            <String, String>{
                'identityProviderId': identityProviderId,
                'error': error,
            }
        );
    }
}

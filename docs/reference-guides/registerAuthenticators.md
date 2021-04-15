
# Register Authenticator


Registers authenticator from [getNotRegisteredAuthenticators] list.


    Future<String> registerAuthenticator(
        BuildContext context, String authenticatorId) async {
      Onegini.instance.setEventContext(context);
      try {
        var data = await Onegini.instance.channel
            .invokeMethod(Constants.registerAuthenticator, <String, String>{
          'authenticatorId': authenticatorId,
        });
        return data;
      } on PlatformException catch (error) {
        throw error;
      }
    }

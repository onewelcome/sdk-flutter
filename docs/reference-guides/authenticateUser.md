
# Authenticate User


Starts authentication flow.
If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
Usually it is Pin authenticator.


    Future<String> authenticateUser(
      BuildContext context,
      String? registeredAuthenticatorId,
    ) async {
      Onegini.instance.setEventContext(context);
      try {
        var userId = await Onegini.instance.channel
            .invokeMethod(Constants.authenticateUser, <String, String?>{
          'registeredAuthenticatorId': registeredAuthenticatorId,
        });
        return userId;
      } on PlatformException catch (error) {
        throw error;
      }
    }

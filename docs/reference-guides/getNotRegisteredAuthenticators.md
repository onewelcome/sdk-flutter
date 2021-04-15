
# Get Not Registered Authenticators


Returns a list of authenticators available to the user, but not yet registered.


    Future<List<OneginiListResponse>> getNotRegisteredAuthenticators(
        BuildContext context) async {
      try {
        var authenticators = await Onegini.instance.channel
            .invokeMethod(Constants.getAllNotRegisteredAuthenticators);
        return responseFromJson(authenticators);
      } on PlatformException catch (error) {
        throw error;
      }
    }


# Get Registered Authenticators


Returns a list of authenticators registered and available to the user.


    Future<List<OneginiListResponse>> getRegisteredAuthenticators(
        BuildContext context) async {
      Onegini.instance.setEventContext(context);
      try {
        var authenticators = await Onegini.instance.channel
            .invokeMethod(Constants.getRegisteredAuthenticators);
        return responseFromJson(authenticators);
      } on PlatformException catch (error) {
        throw error;
      }
    }

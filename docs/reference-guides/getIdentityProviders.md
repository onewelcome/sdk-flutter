
# Get Identity Providers


Returns a list of available identity providers.

    Future<List<OneginiListResponse>> getIdentityProviders(
        BuildContext context) async {
      Onegini.instance.setEventContext(context);
      try {
        var providers = await Onegini.instance.channel
            .invokeMethod(Constants.getIdentityProvidersMethod);
        return responseFromJson(providers);
      } on PlatformException catch (error) {
        throw error;
      }
    }


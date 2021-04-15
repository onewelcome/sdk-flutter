
# Fetch User Profiles


Fetch user profiles.


    Future<String> fetchUserProfiles() async {
      try {
        var profiles = await Onegini.instance.channel
            .invokeMethod(Constants.userProfiles);
        return profiles;
      } on PlatformException catch (error) {
        throw error;
      }
    }

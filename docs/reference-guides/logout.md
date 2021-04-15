
# Logout


Method for log out.


    Future<bool> logout() async {
      try {
        var isSuccess =
            await Onegini.instance.channel.invokeMethod(Constants.logout);
        return isSuccess;
      } on PlatformException catch (error) {
        throw error;
      }
    }


# Deregister User


Deletes the user.


    Future<bool> deregisterUser() async {
      try {
        var isSuccess = await Onegini.instance.channel
            .invokeMethod(Constants.deregisterUserMethod);
        return isSuccess;
      } on PlatformException catch (error) {
        throw error;
      }
    }


# Register User

Start registration flow.
  
If [identityProviderId] is null, starts standard browser registration.
Use your [scopes] for registration. By default it is "read".

```javascript
Future<String> registerUser(
    BuildContext context,
    String? identityProviderId,
    String scopes,
  ) async {
    Onegini.instance.setEventContext(context);
    try {
      var userId = await Onegini.instance.channel
          .invokeMethod(Constants.registerUser, <String, String?>{
        'scopes': scopes,
        'identityProviderId': identityProviderId,
      });
      return userId;
    } on PlatformException catch (error) {
      throw error;
    }
  }
  ```

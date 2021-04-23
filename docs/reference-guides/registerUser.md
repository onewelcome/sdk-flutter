
# Register User

Start registration flow.
  
If [identityProviderId] is null, starts standard browser registration.
Use your [scopes] for registration. By default it is "read".

    var userId = await Onegini.instance.userClient
        .registerUser(context, identityProviderId, "read")
        .catchError((error) {
            print("Registration failed: " + error.message);
        });

    if (userId != null) {
        print("Registration success!");
    }

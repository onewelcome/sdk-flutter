
# Deregister User


Deletes the user.


    var isLogOut = await Onegini.instance.userClient
        .deregisterUser()
        .catchError((error) {
            print("Deregistration failed: " + error.message);
        });

    if (isLogOut) {
       print("User deregistered!");
    }

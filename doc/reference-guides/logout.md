
# Logout


Method for log out.


    var isLogOut = await Onegini.instance.userClient
        .logout()
        .catchError((error) {
            print("Logout failed: " + error.message);
        });

    if (isLogOut) {
       print("User logged out!");
    }

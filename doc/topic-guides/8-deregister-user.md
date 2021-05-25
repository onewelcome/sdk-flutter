# Deregister user

- [Deregistering a user](#Deregistering a user)

## Deregistering a user

Deregistering a user implies the removal of all of their data (including access and refresh tokens) from the device. It also includes a request to the Token Server to revoke all tokens associated with the user. The client credentials will remain stored on the device.

The Onegini Flutter plugin exposes the `Onegini.instance.userClient.deregisterUser()` function to properly deregister a user, as described above.

**Example code to deregister a user:**

    var isLogOut = await Onegini.instance.userClient
        .deregisterUser()
        .catchError((error) {
            print("Deregistration failed: " + error.message);
        });
    
    if (isLogOut) {
       print("User deregistered!");
    }

Note that any existing user can be deregistered. They do not necessarily have to be logged in.

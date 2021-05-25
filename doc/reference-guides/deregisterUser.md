# Deregister user

- [Deregistering a user](#)

## Deregistering a user



Deregistering a user implies the removal of all of their data (including access and refresh tokens) from the device. It also includes a request to the Token Server to revoke all tokens associated with the user. The client credentials will remain stored on the device.

The Onegini Flutter plugin exposes the [`Onegini.instance.userClient.deregisterUser`](#) function to properly deregister a user, as described above.



- Used to deregister for the currently authenticated user.

**Example code to deregister a user:**

```dart
var isLogOut = await Onegini.instance.userClient
    .deregisterUser()
    .catchError((error) {
        print("Deregistration failed: " + error.message);
    });

if (isLogOut) {
   print("User deregistered!");
}
```

The success callback contains bool value:

| Property   | Example | Description                    |
| :--------- | :------ | :----------------------------- |
| `isLogOut` | true    | is user deregistered correctly |



The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |

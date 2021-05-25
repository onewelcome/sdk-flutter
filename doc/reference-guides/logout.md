# Logout

- [`Onegini.instance.userClient.logout`](Onegini.instance.userClient.logout#)

For security reasons, it is always advisable to explicitly logout a user. The Onegini Flutter Plugin exposes the following function to do so.

## `Onegini.instance.userClient.logout`



- Logs out the currently authenticated user.

```dart
var isLogOut = await Onegini.instance.userClient
    .logout()
    .catchError((error) {
        print("Logout failed: " + error.message);
    });

if (isLogOut) {
   print("User logged out!");
}
```

The success callback contains bool value:

| Property   | Example | Description                  |
| :--------- | :------ | :--------------------------- |
| `isLogOut` | true    | is user logged out correctly |

The error callback contains an object with the following properties.

| Property  | Example                           | Description                      |
| :-------- | :-------------------------------- | :------------------------------- |
| `code`    | 8000                              | The error code                   |
| `message` | "Onegini: Internal plugin error." | Human readable error description |

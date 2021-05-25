
# Authenticate User

Starts authentication flow.
If [registeredAuthenticatorId] is null, starts authentication by default authenticator.
Usually it is Pin authenticator.



## `onegini.user.authenticate`



- 
  Used to authenticate a user.
- Requires an object containing a `context`, `authenticatorId`.

| Property          | Default | Description                                                  |
| :---------------- | :------ | :----------------------------------------------------------- |
| `context`         | -       | The context of your screen                                   |
| `authenticatorId` | -       | Id of the authenticator through which you want to authenticate. Can be `null`. |


```dart
var userId = await Onegini.instance.userClient
    .authenticateUser(context, registeredAuthenticatorId)
    .catchError((error) {
        print("Authentication failed: " + error.message);
    });

if (userId != null) {
    print("Authentication success!");
}
```

The success callback contains String `userId`  value:

| Property | Example | Description |
| :------- | :------ | :---------- |
| `userId` | QWERTY  | Id of user  |



The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |


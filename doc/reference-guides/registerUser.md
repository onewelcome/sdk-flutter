# Registration

- [`Onegini.instance.userClient.registerUser`](#`)

Before a user can authenticate using PIN or fingerprint, a user will need to register with your Token Server. Registration can be initiated using this method.

## `Onegini.instance.userClient.registerUser`



- Returns a [`RegistrationResponse`](#) object.
- Takes objects with a `context`, `identityProviderId`  and `scopes`  property:

| Property             | Default              | Description                                              |
| :------------------- | :------------------- | :------------------------------------------------------- |
| `scopes`             | server configuration | An array of scopes the user will register for (optional) |
| `context`            | -                    | context of your widget                                   |
| `identityProviderId` | null                 | Id of `OneginiIdentetyProvider`                          |

```dart
var userId = await Onegini.instance.userClient
    .registerUser(context, identityProviderId, "read")
    .catchError((error) {
        print("Registration failed: " + error.message);
    });

if (userId != null) {
    print("Registration success!");
}
```

The success callback contains `RegistrationResponse` objects with these properties:

| Property      | Example     | Description                                                  |
| :------------ | :---------- | :----------------------------------------------------------- |
| `userProfile` | UserProfile | A class contain `profileId` and `isDefault` properties       |
| `customInfo`  | CustomInfo  | A class contain `status` and `data` properties. This class can be `null`. |

The error callback contains an object with the following properties.

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |


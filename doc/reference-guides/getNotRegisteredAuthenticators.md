
# Get Not Registered Authenticators

- [`Onegini.instance.userClient.getNotRegisteredAuthenticators`](#Onegini.instance.userClient.getNotRegisteredAuthenticators)

## `onegini.user.authenticators.getNotRegistered`

- Used to get an array of authenticators that are *not currently registered* for a specific user.
- Requires an object containing a `context`:

```dart
var authenticators = await Onegini.instance.userClient
        .getNotRegisteredAuthenticators(context);
if (authenticators.isNotEmpty) {
    print('Not registered authenticators');
}
```

The success callback contains an array of objects with these properties:

| Property | Example | Description                                                  |
| :------- | :------ | :----------------------------------------------------------- |
| `name`   | "PIN"   | The authenticator name                                       |
| `id`     | "PIN"   | The authenticator ID, which distinguishes between authenticators of type "Custom". (Only required for custom authenticators) |

The error callback contains an object with these properties:

| Property  | Example                              | Description                      |
| :-------- | :----------------------------------- | :------------------------------- |
| `code`    | 8003                                 | The error code                   |
| `message` | "Onegini: No registered user found." | Human readable error description |


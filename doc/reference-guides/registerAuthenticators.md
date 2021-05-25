# Register Authenticator

## `Onegini.instance.userClient.registerAuthenticator`



- Used to register a new authenticator for the currently authenticated user.
- Requires an argument with an `authenticatorType`:

| Property          | Example | Description                                                  |
| :---------------- | :------ | :----------------------------------------------------------- |
| `context`         | -       | The context of your widget                                   |
| `authenticatorId` | "PIN"   | The authenticator ID, which distinguishes between authenticators of type "Custom". (Only required for custom authenticators) |

```dart
 await Onegini.instance.userClient
        .registerAuthenticator(context, authenticatorId)
        .catchError((error) {
      	}
    });
```

The success callback contains bool value:

| Property    | Example | Description                        |
| :---------- | :------ | :--------------------------------- |
| `isSuccess` | true    | authenticator registered correctly |

The error callback contains an object with the following properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |

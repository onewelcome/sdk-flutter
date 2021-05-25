# changePin

- [`onegini.user.changePin`](#)

## `onegini.user.changePin`

- Used to change pin  for the currently authenticated user.
- Requires an object containing a `context`.
- No returns value.

| Property  | Default | Description                |
| :-------- | :------ | :------------------------- |
| `context` | -       | The context of your screen |

**Example code changing a user's PIN:**

```dart
Onegini.instance.userClient
    .changePin(context)
    .catchError((error) {
    if (error is PlatformException) {
        print("Pin change failed");
    }
});
```

The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |

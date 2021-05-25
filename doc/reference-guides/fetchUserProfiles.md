# Fetch User Profiles

- [`Onegini.instance.userClient.fetchUserProfiles`](#)

The Onegini Flutter Plugin maintains a set of profiles that you have created. This method allows you to retrieve all existing profiles.

## `Onegini.instance.userClient.fetchUserProfiles`

- Used to get an array of all existing userProfiles.

```dart
var users = await Onegini.instance.userClient
    .fetchUserProfiles()
    .catchError((error) {
        print("Error: " + error.message);
    });;
```

The success value contains an array of objects with these properties:

| Property    | Example | Description                           |
| :---------- | :------ | :------------------------------------ |
| `profileId` | -       | A profile ID associated with the user |

The error callback contains an object with these properties:

| Property  | Example         | Description                      |
| :-------- | :-------------- | :------------------------------- |
| `code`    | 10000           | The error code                   |
| `message` | "General error" | Human readable error description |


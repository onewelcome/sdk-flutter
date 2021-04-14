# Start


The first thing that needs to be done when the app starts is to initizialize the Onegini Flutter Plugin. This will perform a few checks and report an error in case of trouble.

```dart
Future<List<RemovedUserProfile>> startApplication(
    OneginiEventListener eventListener, {
    List<String>? twoStepCustomIdentityProviderIds,
    int? connectionTimeout,
    int? readTimeout,
  }) async {
    _eventListener = eventListener;
    try {
      String removedUserProfiles = await channel
          .invokeMethod(Constants.startAppMethod, <String, dynamic>{
        'twoStepCustomIdentityProviderIds':
            twoStepCustomIdentityProviderIds?.join(","),
        'connectionTimeout': connectionTimeout,
        'readTimeout': readTimeout
      });
      eventListener.listen();
      return removedUserProfileListFromJson(removedUserProfiles);
    } on PlatformException catch (error) {
      throw error;
    }
  }
```

# Pidgeon
Pidgeon is used within this project to enable type-save communication between the native platforms.

Command for code generation which is performed from top level:
flutter pub run pigeon \
  --input pigeons/userProfile.dart \
  --dart_out lib/pigeon.dart \
  --experimental_kotlin_out ./android/src/main/kotlin/com/onegini/mobile/sdk/flutter/pigeonPlugin/Pigeon.kt  \
  --experimental_kotlin_package "com.onegini.mobile.sdk.flutter.pigeonPlugin" \
  --experimental_swift_out ios/Classes/Pigeon.swift

## Missing documentation
Pigeon is poorly documented; so to keep knowledge on why and how certain things are done we will refer to pull requests where we obtained information.

### iOS Platform Exceptions
By default, it is not possible to return custom platform exceptions through pigeon, however a merged feature has made this possible.
The steps to obtain this such that we can call "completion(.failure(SdkError(.userProfileDoesNotExist).flutterError()))" for example is explained in this PR:
https://github.com/flutter/packages/pull/3084

### Android Platform Exception
Currently, it is not possible to send custom platform exceptions back using the (code, message, details) structure. This PR is requesting it and we hope it gets added soon:
https://github.com/flutter/flutter/issues/120861

### Triggering event functions from Native
We can use @FlutterApi to call functions on the dart side from the Native parts. However, as always this is not ducumented but there is an open documentation issue that gives some references with more information
https://github.com/flutter/flutter/issues/108531

where https://github.com/zero-li/flutter_pigeon_plugin  gives a simple example project (with chines documentation) but gives a good idea on how it works as a reference.

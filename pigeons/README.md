# Pidgeon
Pidgeon is used within this project to enable type-save communication between the native platforms.

Command for code generation which is performed from top level:
flutter pub run pigeon \
  --input pigeons/userProfile.dart \
  --dart_out lib/pigeon.dart \
  --experimental_kotlin_out ./android/src/main/kotlin/com/onegini/mobile/sdk/flutter/pigeonPlugin/Pigeon.kt  \
  --experimental_kotlin_package "com.onegini.mobile.sdk.flutter.pigeonPlugin" \
  --experimental_swift_out ios/Classes/Pigeon.swift
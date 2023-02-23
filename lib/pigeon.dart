// Autogenerated from Pigeon (v9.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum State {
  success,
  error,
}

class OneWelcomeNativeError {
  OneWelcomeNativeError({
    required this.code,
    required this.message,
    required this.details,
  });

  String code;

  String message;

  Map<String?, Object?> details;

  Object encode() {
    return <Object?>[
      code,
      message,
      details,
    ];
  }

  static OneWelcomeNativeError decode(Object result) {
    result as List<Object?>;
    return OneWelcomeNativeError(
      code: result[0]! as String,
      message: result[1]! as String,
      details: (result[2] as Map<Object?, Object?>?)!.cast<String?, Object?>(),
    );
  }
}

class UserProfile {
  UserProfile({
    required this.profileId,
  });

  String profileId;

  Object encode() {
    return <Object?>[
      profileId,
    ];
  }

  static UserProfile decode(Object result) {
    result as List<Object?>;
    return UserProfile(
      profileId: result[0]! as String,
    );
  }
}

class UserProfilesResult {
  UserProfilesResult({
    required this.state,
    this.success,
    this.error,
  });

  State state;

  List<UserProfile?>? success;

  OneWelcomeNativeError? error;

  Object encode() {
    return <Object?>[
      state.index,
      success,
      error?.encode(),
    ];
  }

  static UserProfilesResult decode(Object result) {
    result as List<Object?>;
    return UserProfilesResult(
      state: State.values[result[0]! as int],
      success: (result[1] as List<Object?>?)?.cast<UserProfile?>(),
      error: result[2] != null
          ? OneWelcomeNativeError.decode(result[2]! as List<Object?>)
          : null,
    );
  }
}

class PigeonUserProfile {
  PigeonUserProfile({
    required this.profileId,
    required this.isDefault,
  });

  String profileId;

  bool isDefault;

  Object encode() {
    return <Object?>[
      profileId,
      isDefault,
    ];
  }

  static PigeonUserProfile decode(Object result) {
    result as List<Object?>;
    return PigeonUserProfile(
      profileId: result[0]! as String,
      isDefault: result[1]! as bool,
    );
  }
}

class _UserClientApiCodec extends StandardMessageCodec {
  const _UserClientApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is OneWelcomeNativeError) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is PigeonUserProfile) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is UserProfile) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is UserProfilesResult) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return OneWelcomeNativeError.decode(readValue(buffer)!);
      case 129: 
        return PigeonUserProfile.decode(readValue(buffer)!);
      case 130: 
        return UserProfile.decode(readValue(buffer)!);
      case 131: 
        return UserProfilesResult.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// Flutter calls native
class UserClientApi {
  /// Constructor for [UserClientApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  UserClientApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _UserClientApiCodec();

  Future<List<PigeonUserProfile?>> fetchUserProfiles() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.UserClientApi.fetchUserProfiles', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<PigeonUserProfile?>();
    }
  }

  Future<UserProfilesResult> testFunction() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.UserClientApi.testFunction', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as UserProfilesResult?)!;
    }
  }
}

/// Native calls Flutter
abstract class NativeCallFlutterApi {
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  Future<String> testEventFunction(String argument);

  static void setup(NativeCallFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.NativeCallFlutterApi.testEventFunction', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.NativeCallFlutterApi.testEventFunction was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_argument = (args[0] as String?);
          assert(arg_argument != null,
              'Argument for dev.flutter.pigeon.NativeCallFlutterApi.testEventFunction was null, expected non-null String.');
          final String output = await api.testEventFunction(arg_argument!);
          return output;
        });
      }
    }
  }
}

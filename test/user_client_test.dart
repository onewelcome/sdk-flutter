import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/user_client.dart';

void main() {
  late UserClient userClient;
  late MethodChannel methodChannel;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    userClient = UserClient();
    methodChannel = const MethodChannel('onegini');
  });

  void setupMethodChannel(String method, Future returnValue) {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (methodCall) async {
      if (methodCall.method == method) {
        return returnValue;
      }
      return 0;
    });
  }

  group('UserClient registerUser', () {
    test(
      'return RegistrationResponse',
      () async {
        //arrange
        setupMethodChannel(Constants.registerUser,
            Future.value('{"userProfile":{"profileId":"1234"}}'));

        var result = await userClient.registerUser(null, '', []);

        //assert
        expect(result.userProfile?.profileId, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.registerUser, Future.value(null));

        //assert
        expect(() async => await userClient.registerUser(null, '', []),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.registerUser, Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.registerUser(null, '', []),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getIdentityProviders', () {
    test(
      'return List<OneginiListResponse>',
      () async {
        //arrange
        setupMethodChannel(Constants.getIdentityProvidersMethod,
            Future.value('[{"id" : "1234", "name" : "name"}]'));

        //act
        var result = await userClient.getIdentityProviders(null);

        //assert
        expect(result.first.id, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getIdentityProvidersMethod, Future.value(null));

        //assert
        expect(() async => await userClient.getIdentityProviders(null),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getIdentityProvidersMethod,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getIdentityProviders(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient deregisterUser', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(Constants.deregisterUserMethod, Future.value(true));

        //act
        var result = await userClient.deregisterUser('1234');

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(Constants.deregisterUserMethod, Future.value(false));

        //act
        var result = await userClient.deregisterUser('1234');

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(Constants.deregisterUserMethod, Future.value(null));

        //act
        var result = await userClient.deregisterUser('1234');

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.deregisterUserMethod,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.deregisterUser('1234'),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getRegisteredAuthenticators', () {
    test(
      'return List<OneginiListResponse>',
      () async {
        //arrange
        setupMethodChannel(Constants.getRegisteredAuthenticators,
            Future.value('[{"id" : "1234", "name" : "name"}]'));

        //act
        var result = await userClient.getRegisteredAuthenticators(null);

        //assert
        expect(result.first.id, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getRegisteredAuthenticators, Future.value(null));

        //assert
        expect(() async => await userClient.getIdentityProviders(null),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getRegisteredAuthenticators,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getRegisteredAuthenticators(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getAllAuthenticators', () {
    test(
      'return List<OneginiListResponse>',
      () async {
        //arrange
        setupMethodChannel(Constants.getAllAuthenticators,
            Future.value('[{"id" : "1234", "name" : "name"}]'));

        //act
        var result = await userClient.getAllAuthenticators(null);

        //assert
        expect(result.first.id, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAllAuthenticators, Future.value(null));

        //assert
        expect(() async => await userClient.getAllAuthenticators(null),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAllAuthenticators,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getAllAuthenticators(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient authenticateUser', () {
    test(
      'return RegistrationResponse',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateUser,
            Future.value('{"userProfile":{"profileId":"1234"}}'));

        //act
        var result = await userClient.authenticateUser(null, '');

        //assert
        expect(result.userProfile?.profileId, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateUser, Future.value(null));

        //assert
        expect(() async => await userClient.authenticateUser(null, ''),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateUser,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.authenticateUser(null, ''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getNotRegisteredAuthenticators', () {
    test(
      'return List<OneginiListResponse>',
      () async {
        //arrange
        setupMethodChannel(Constants.getAllNotRegisteredAuthenticators,
            Future.value('[{"id" : "1234", "name" : "name"}]'));

        //act
        var result = await userClient.getNotRegisteredAuthenticators(null);

        //assert
        expect(result.first.id, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getAllNotRegisteredAuthenticators, Future.value(null));

        //assert
        expect(
            () async => await userClient.getNotRegisteredAuthenticators(null),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAllNotRegisteredAuthenticators,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(
            () async => await userClient.getNotRegisteredAuthenticators(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient registerAuthenticator', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.registerAuthenticator, Future.value('success'));

        //act
        var result =
            await userClient.registerAuthenticator(null, 'fingerprint');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(Constants.registerAuthenticator, Future.value(null));

        //act
        var result =
            await userClient.registerAuthenticator(null, 'fingerprint');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.registerAuthenticator,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(
            () async =>
                await userClient.registerAuthenticator(null, 'fingerprint'),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient isAuthenticatorRegistered', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(
            Constants.isAuthenticatorRegistered, Future.value(true));

        //act
        var result = await userClient.isAuthenticatorRegistered('fingerprint');

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(
            Constants.isAuthenticatorRegistered, Future.value(false));

        //act
        var result = await userClient.isAuthenticatorRegistered('fingerprint');

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(
            Constants.isAuthenticatorRegistered, Future.value(null));

        //act
        var result = await userClient.isAuthenticatorRegistered('fingerprint');

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.isAuthenticatorRegistered,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(
            () async =>
                await userClient.isAuthenticatorRegistered('fingerprint'),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient deregisterAuthenticator', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(
            Constants.deregisterAuthenticator, Future.value(true));

        //act
        var result =
            await userClient.deregisterAuthenticator(null, 'fingerprint');

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(
            Constants.deregisterAuthenticator, Future.value(false));

        //act
        var result =
            await userClient.deregisterAuthenticator(null, 'fingerprint');

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(
            Constants.deregisterAuthenticator, Future.value(null));

        //act
        var result =
            await userClient.deregisterAuthenticator(null, 'fingerprint');

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.deregisterAuthenticator,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(
            () async =>
                await userClient.deregisterAuthenticator(null, 'fingerprint'),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient logout', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(Constants.logout, Future.value(true));

        //act
        var result = await userClient.logout();

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(Constants.logout, Future.value(false));

        //act
        var result = await userClient.logout();

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(Constants.logout, Future.value(null));

        //act
        var result = await userClient.logout();

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.logout, Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.logout(),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient mobileAuthWithOtp', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.handleMobileAuthWithOtp, Future.value('success'));

        //act
        var result = await userClient.mobileAuthWithOtp('');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(
            Constants.handleMobileAuthWithOtp, Future.value(null));

        //act
        var result = await userClient.mobileAuthWithOtp('');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.handleMobileAuthWithOtp,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.mobileAuthWithOtp(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getAppToWebSingleSignOn', () {
    test(
      'return OneginiAppToWebSingleSignOn',
      () async {
        //arrange
        setupMethodChannel(Constants.getAppToWebSingleSignOn,
            Future.value('{"token": "1234", "redirectUrl" : ""}'));

        var result = await userClient.getAppToWebSingleSignOn('');

        //assert
        expect(result.token, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getAppToWebSingleSignOn, Future.value(null));

        //assert
        expect(() async => await userClient.getAppToWebSingleSignOn(''),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAppToWebSingleSignOn,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getAppToWebSingleSignOn(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient fetchUserProfiles', () {
    test(
      'return List<UserProfile>',
      () async {
        //arrange
        setupMethodChannel(Constants.userProfiles,
            Future.value('[{"profileId":"1234","isDefault":true}]'));

        //act
        var result = await userClient.fetchUserProfiles();

        //assert
        expect(result.first.profileId, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.userProfiles, Future.value(null));

        //assert
        expect(() async => await userClient.fetchUserProfiles(),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.userProfiles, Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.fetchUserProfiles(),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient validatePinWithPolicy', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(Constants.validatePinWithPolicy, Future.value(true));

        //act
        var result = await userClient.validatePinWithPolicy('');

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(
            Constants.validatePinWithPolicy, Future.value(false));

        //act
        var result = await userClient.validatePinWithPolicy('');

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(Constants.validatePinWithPolicy, Future.value(null));

        //act
        var result = await userClient.validatePinWithPolicy('');

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.validatePinWithPolicy,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.validatePinWithPolicy(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getAccessToken', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(Constants.getAccessToken, Future.value('success'));

        //act
        var result = await userClient.getAccessToken();

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(Constants.getAccessToken, Future.value(null));

        //act
        var result = await userClient.getAccessToken();

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAccessToken,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getAccessToken(),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getRedirectUrl', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(Constants.getRedirectUrl, Future.value('success'));

        //act
        var result = await userClient.getRedirectUrl('');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(Constants.getRedirectUrl, Future.value(null));

        //act
        var result = await userClient.getRedirectUrl('');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getRedirectUrl,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getRedirectUrl(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient getAuthenticatedUserProfile', () {
    test(
      'return UserProfile',
      () async {
        //arrange
        setupMethodChannel(Constants.getAuthenticatedUserProfile,
            Future.value('{"profileId":"1234"}'));

        var result = await userClient.getAuthenticatedUserProfile();

        //assert
        expect(result.profileId, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getAuthenticatedUserProfile, Future.value(null));

        //assert
        expect(() async => await userClient.getAuthenticatedUserProfile(),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getAuthenticatedUserProfile,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.getAuthenticatedUserProfile(),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient authenticateDevice', () {
    test(
      'return true',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice, Future.value(true));

        //act
        var result = await userClient.authenticateDevice(null);

        //assert
        expect(result, true);
      },
    );

    test(
      'return false',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice, Future.value(false));

        //act
        var result = await userClient.authenticateDevice(null);

        //assert
        expect(result, false);
      },
    );

    test(
      'return null defaults to false',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice, Future.value(null));

        //act
        var result = await userClient.authenticateDevice(null);

        //assert
        expect(result, false);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.authenticateDevice(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('UserClient authenticateUserImplicitly', () {
    test(
      'return UserProfile',
      () async {
        //arrange
        setupMethodChannel(
            Constants.authenticateDevice, Future.value('{"profileId":"1234"}'));

        var result = await userClient.authenticateUserImplicitly(null);

        //assert
        expect(result.profileId, '1234');
      },
    );

    test(
      'return null, handle TypeError and throw PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice, Future.value(null));

        //assert
        expect(() async => await userClient.authenticateUserImplicitly(null),
            throwsA(isA<PlatformException>()));
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.authenticateDevice,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await userClient.authenticateUserImplicitly(null),
            throwsA(isA<PlatformException>()));
      },
    );
  });
}

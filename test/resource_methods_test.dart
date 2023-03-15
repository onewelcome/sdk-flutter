import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onegini/constants/constants.dart';
import 'package:onegini/resources_methods.dart';

void main() {
  late ResourcesMethods resourcesMethods;
  late MethodChannel methodChannel;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    resourcesMethods = ResourcesMethods();
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

  group('ResourcesMethods getResourceAnonymous', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getResourceAnonymous, Future.value('success'));

        //act
        var result = await resourcesMethods.getResourceAnonymous('');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(Constants.getResourceAnonymous, Future.value(null));

        //act
        var result = await resourcesMethods.getResourceAnonymous('');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getResourceAnonymous,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await resourcesMethods.getResourceAnonymous(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('ResourcesMethods getResource', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(Constants.getResource, Future.value('success'));

        //act
        var result = await resourcesMethods.getResource('');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(Constants.getResource, Future.value(null));

        //act
        var result = await resourcesMethods.getResource('');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getResource, Future.error(PlatformException(code: '1')));

        //assert
        expect(() async => await resourcesMethods.getResource(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('ResourcesMethods getResourceUnauthenticated', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getUnauthenticatedResource, Future.value('success'));

        //act
        var result = await resourcesMethods.getResourceUnauthenticated('');

        //assert
        expect(result, 'success');
      },
    );

    test(
      'return null',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getUnauthenticatedResource, Future.value(null));

        //act
        var result = await resourcesMethods.getResourceUnauthenticated('');

        //assert
        expect(result, null);
      },
    );

    test(
      'handle PlatformException',
      () async {
        //arrange
        setupMethodChannel(Constants.getUnauthenticatedResource,
            Future.error(PlatformException(code: '1')));

        //assert
        expect(
            () async => await resourcesMethods.getResourceUnauthenticated(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });
}

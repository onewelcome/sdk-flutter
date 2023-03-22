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

  group('ResourcesMethods requestResourceAnonymous', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getResourceAnonymous, Future.value('success'));

        //act
        var result = await resourcesMethods.requestResourceAnonymous('');

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
        var result = await resourcesMethods.requestResourceAnonymous('');

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
        expect(() async => await resourcesMethods.requestResourceAnonymous(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('ResourcesMethods requestResource', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(Constants.getResource, Future.value('success'));

        //act
        var result = await resourcesMethods.requestResource('');

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
        var result = await resourcesMethods.requestResource('');

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
        expect(() async => await resourcesMethods.requestResource(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });

  group('ResourcesMethods requestResourceUnauthenticated', () {
    test(
      'return String',
      () async {
        //arrange
        setupMethodChannel(
            Constants.getUnauthenticatedResource, Future.value('success'));

        //act
        var result = await resourcesMethods.requestResourceUnauthenticated('');

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
        var result = await resourcesMethods.requestResourceUnauthenticated('');

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
            () async => await resourcesMethods.requestResourceUnauthenticated(''),
            throwsA(isA<PlatformException>()));
      },
    );
  });
}

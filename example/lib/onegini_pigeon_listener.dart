import 'package:onegini/pigeon.dart';

class OneginiPigeonListenerImpl extends NativeCallFlutterApi {
  @override
  Future<String> testEventFunction(String argument) async {
    print("testEventFunction was triggered from native: $argument");
    return "boop";
  }
}

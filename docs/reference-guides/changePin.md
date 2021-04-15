
# Change Pin


Starts change pin flow.


```javascript
Future<void> changePin(
  BuildContext context,
) async {
  Onegini.instance.setEventContext(context);
  try {
    await Onegini.instance.channel.invokeMethod(Constants.changePin);
  } on PlatformException catch (error) {
    throw error;
  }
}
```

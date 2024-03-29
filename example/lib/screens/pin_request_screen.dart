import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_pin_registration_callback.dart';
import 'package:onegini/onegini.dart';

import '../components/display_toast.dart';

class PinRequestScreen extends StatefulWidget {
  final bool confirmation;
  final String previousCode;

  final bool customAuthenticator;

  const PinRequestScreen(
      {Key? key,
      this.confirmation = false,
      this.previousCode = "",
      this.customAuthenticator = false})
      : super(key: key);

  @override
  _PinRequestScreenState createState() => _PinRequestScreenState();
}

class _PinRequestScreenState extends State<PinRequestScreen> {
  var pinCode = List<String>.filled(5, "");

  enterNum(String num) {
    for (var i = 0; i < pinCode.length; i++) {
      if (pinCode[i] == "") {
        setState(() => pinCode[i] = num);
        break;
      }
    }
    if (!pinCode.contains("")) {
      done();
    }
  }

  clearAllDigits() {
    for (var i = 0; i < pinCode.length; i++) {
      setState(() => pinCode[i] = "");
    }
  }

  removeLast() {
    for (var i = 0; i < pinCode.length; i++) {
      if (pinCode[i] == "" && i != 0) {
        setState(() => pinCode[i - 1] = "");
        break;
      }
      if (pinCode[i] != "" && i == pinCode.length - 1) {
        setState(() => pinCode[i] = "");
        break;
      }
    }
  }

  done() async {
    String pin = "";
    pinCode.forEach((element) {
      pin += element;
    });
    if (widget.confirmation) {
      if (pin == widget.previousCode) {
        OneginiPinRegistrationCallback()
            .acceptAuthenticationRequest(pin)
            .catchError((error) {
          if (error is PlatformException) {
            showFlutterToast(error.message);
          }
        });
      } else {
        showFlutterToast("pins don't match, please try again");
        Navigator.of(context)
          ..pop()
          ..push(
            MaterialPageRoute(
                builder: (context) => PinRequestScreen(
                      customAuthenticator: this.widget.customAuthenticator,
                    )),
          );
      }
    } else {
      try {
        await Onegini.instance.userClient.validatePinWithPolicy(pin);
        Navigator.of(context)
          ..pop()
          ..push(
            MaterialPageRoute(
                builder: (context) => PinRequestScreen(
                      confirmation: true,
                      previousCode: pin,
                      customAuthenticator: this.widget.customAuthenticator,
                    )),
          );
      } on PlatformException catch (error) {
        clearAllDigits();
        showFlutterToast(error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OneginiPinRegistrationCallback().denyAuthenticationRequest();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("PIN"),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                widget.confirmation ? "Confirm PIN code" : "Enter PIN code",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pinCode.map((e) => pinItem(e)).toList(),
              ),
              Spacer(),
              NumPad(
                enterNum: enterNum,
                removeLast: removeLast,
                done: () => {},
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pinItem(String item) {
    return item == ""
        ? Container(
            width: 10,
            height: 2,
            color: Colors.black,
          )
        : Text(
            "*",
            style: TextStyle(fontSize: 30),
          );
  }
}

class NumPad extends StatelessWidget {
  final Function(String) enterNum;
  final Function removeLast;
  final Function done;

  const NumPad(
      {Key? key,
      required this.enterNum,
      required this.removeLast,
      required this.done})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              numItem("1", enterNum),
              numItem("2", enterNum),
              numItem("3", enterNum),
            ],
          ),
          Row(
            children: [
              numItem("4", enterNum),
              numItem("5", enterNum),
              numItem("6", enterNum),
            ],
          ),
          Row(
            children: [
              numItem("7", enterNum),
              numItem("8", enterNum),
              numItem("9", enterNum),
            ],
          ),
          Row(
            children: [
              additionalItem("<-", removeLast),
              numItem("0", enterNum),
              additionalItem("Done", done),
            ],
          )
        ],
      ),
    );
  }

  Widget numItem(String text, Function(String) onTap) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        child: TextButton(
          onPressed: () => onTap(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget additionalItem(String text, Function onTap) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        child: TextButton(
          onPressed: () => onTap(),
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

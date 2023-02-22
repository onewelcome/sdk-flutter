// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/callbacks/onegini_pin_authentication_callback.dart';

import '../components/display_toast.dart';

class PinScreen extends StatefulWidget {
  final PinScreenController controller;

  PinScreen({this.controller});

  @override
  _PinScreenState createState() => _PinScreenState(controller);
}

class PinScreenController {
  void Function() clearState;
}

class _PinScreenState extends State<PinScreen> {
  List<String> pinCode = List<String>.filled(5, null);
  var isLoading = false;

  _PinScreenState(PinScreenController _controller) {
    _controller.clearState = clearState;
  }

  void clearState() {
    setState(() {
      isLoading = false;
      pinCode = List<String>.filled(5, null);
    });
  }

  enterNum(String num) {
    for (var i = 0; i < pinCode.length; i++) {
      if (pinCode[i] == null) {
        setState(() => pinCode[i] = num);
        // if last pin digit is provided
        if (i == pinCode.length - 1) {
          submit();
        }
        break;
      }
    }
  }

  removeLast() {
    for (var i = 0; i < pinCode.length; i++) {
      if (pinCode[i] == null && i != 0) {
        setState(() => pinCode[i - 1] = null);
        break;
      }
      if (pinCode[i] != null && i == pinCode.length - 1) {
        setState(() => pinCode[i] = null);
        break;
      }
    }
  }

  submit() {
    setState(() => {isLoading = true});
    String pin = "";
    pinCode.forEach((element) {
      pin += element;
    });
    OneginiPinAuthenticationCallback()
        .acceptAuthenticationRequest(context, pin: pin)
        .catchError((error) {
      if (error is PlatformException) {
        setState(() => {isLoading = false});
        showFlutterToast(error.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await OneginiPinAuthenticationCallback().denyAuthenticationRequest();
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
                "Enter PIN code",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pinCode.map((e) => pinItem(e)).toList(),
              ),
              Spacer(),
              isLoading
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : NumPad(
                      enterNum: enterNum,
                      removeLast: removeLast,
                    ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pinItem(String item) {
    return item == null
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

  const NumPad({Key key, this.enterNum, this.removeLast}) : super(key: key);

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
              Spacer()
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
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

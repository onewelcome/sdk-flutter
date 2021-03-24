// @dart = 2.10
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onegini/callbacks/onegini_pin_authentication_callback.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  var pinCode = new List(5);

  enterNum(String num) {
    for (var i = 0; i < pinCode.length; i++) {
      if (pinCode[i] == null) {
        setState(() => pinCode[i] = num);
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

  done() {
    String pin = "";
    pinCode.forEach((element) {
      pin += element;
    });
    OneginiPinAuthenticationCallback()
        .acceptAuthenticationRequest(context, pin: pin)
        .catchError((error) {
      if (error is PlatformException) {
        Fluttertoast.showToast(
            msg: error.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black38,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          OneginiPinAuthenticationCallback().denyAuthenticationRequest(),
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
              NumPad(
                enterNum: enterNum,
                removeLast: removeLast,
                done: pinCode.contains(null) ? null : done,
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
  final Function done;
  const NumPad({Key key, this.enterNum, this.removeLast, this.done})
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
        child: FlatButton(
          height: 50,
          onPressed: () => onTap(text),
          color: Colors.blue,
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
        child: FlatButton(
          height: 50,
          onPressed: onTap,
          color: Colors.blue,
          disabledColor: Colors.grey[500],
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

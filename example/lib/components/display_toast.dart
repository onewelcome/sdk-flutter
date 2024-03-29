import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showFlutterToast(String? message) {
  Fluttertoast.showToast(
      msg: message ?? "No message in error",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0);
}

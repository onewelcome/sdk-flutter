// @dart = 2.10
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanScreen extends StatefulWidget {
  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  Barcode result;
  int counter = 0;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  void onQRViewCreated(QRViewController controllerr) {
    setState(() => controller = controllerr);
    controller.scannedDataStream.listen((scanData) {
      if (counter >= 1) {
        return;
      }
      sendDataBack(scanData.code);
    });
  }

  sendDataBack(String data) async {
    counter++;
    await controller.pauseCamera();
    if (counter >= 1) {
      controller.stopCamera();
      Navigator.of(context)..pop(data);
    }
  }

  Widget _buildQr(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQr(context)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

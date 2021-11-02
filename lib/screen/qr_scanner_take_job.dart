import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerTakeJob extends StatefulWidget {
  QRScannerTakeJob({Key? key}) : super(key: key);

  @override
  _QRScannerTakeJobState createState() => _QRScannerTakeJobState();
}

class _QRScannerTakeJobState extends State<QRScannerTakeJob> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          QRView(
            overlay: QrScannerOverlayShape(
                borderWidth: 10,
                borderLength: 20,
                borderRadius: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8),
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(top: 10, child: buildResult()),
          Positioned(bottom: 10, child: buildButton()),
        ],
      ),
    );
  }

  buildResult() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white30, borderRadius: BorderRadius.circular(8)),
      child: Text(
        result != null ? 'Result : ${result?.code}' : 'Scan a code!',
        maxLines: 3,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  buildButton() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white30, borderRadius: BorderRadius.circular(8)),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  setState(() {});
                  await controller?.flipCamera();
                },
                icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(Icons.switch_camera);
                    } else {
                      return Icon(Icons.switch_camera);
                    }
                  },
                ),
              ),
              IconButton(
                icon: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.data != null) {
                      print(snapshot.data);
                      return Icon(snapshot.data != false
                          ? Icons.flash_on
                          : Icons.flash_off);
                    } else {
                      return Icon(Icons.flash_off);
                    }
                  },
                ),
                onPressed: () async {
                  setState(() {});
                  await controller?.toggleFlash();
                },
              ),
            ]));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}

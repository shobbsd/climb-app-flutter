import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:climbAppFlutter/pages/BarcodeForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Scanner extends StatefulWidget {
  final Map user;
  final ScreenChangeCallback changeScreen;
  @override
  _ScannerState createState() => _ScannerState();

  Scanner({this.user, this.changeScreen});
}

class _ScannerState extends State<Scanner> {
  String barcode = "";
  @override
  Future start() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BarcodeForm(barcode, widget.user)));
      widget.changeScreen(0);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
        print('yo');
      } else if (e.code == BarcodeScanner.UserCanceled) {
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      print("format exception");
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void initState() {
    // TODO: implement initState
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            child: MaterialButton(
              onPressed: start,
              child: Text("Scan"),
              color: Colors.red,
            ),
            padding: const EdgeInsets.all(8.0),
          ),
          Text(barcode),
        ],
      ),
    );
  }
}

typedef ScreenChangeCallback(index);

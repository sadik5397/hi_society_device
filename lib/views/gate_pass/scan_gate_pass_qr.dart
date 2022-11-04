import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hi_society_device/views/gate_pass/verify_gate_pass.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../../theme/text_style.dart';

class ScanGatePassQR extends StatefulWidget {
  const ScanGatePassQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanGatePassQRState();
}

class _ScanGatePassQRState extends State<ScanGatePassQR> {
  //Variables
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool cameraPaused = false;

  //Functions
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * .75;
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) => setState(() => result = scanData));
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  //Initiate
  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
    controller?.flipCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: trueWhite,
        body: Column(children: [
          Expanded(
              child: Stack(alignment: Alignment.bottomCenter, children: [
            _buildQrView(context),
            Padding(
                padding: primaryPadding,
                child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text("If you have a Digital Gate Pass coupon with QR code,", style: semiBold14White, textAlign: TextAlign.center),
                  Text("open it and face it to the screen", style: semiBold14White, textAlign: TextAlign.center),
                  Text("Scan The QR Code", style: bold22White)
                ]))
          ])),
          Padding(
              padding: primaryPadding * 2,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(bottom: primaryPaddingValue),
                    child: Text((result != null) ? "QR Code Found! Tap Submit to Proceed" : "Having trouble scanning QR code?", textAlign: TextAlign.center, style: normal14Black)),
                (result != null)
                    ? primaryButton(
                        context: context,
                        title: "Submit",
                        onTap: () async {
                          route(context, VerifyGatePass(gatePassCode: result!.code.toString()));
                          await controller?.pauseCamera();
                        })
                    : primaryButton(
                        context: context,
                        primary: false,
                        title: "Type the CODE Manually",
                        onTap: () async {
                          routeBack(context);
                          await controller?.pauseCamera();
                        })
              ]))
        ]));
  }
}

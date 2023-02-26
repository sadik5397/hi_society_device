import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hi_society_device/api/i18n.dart';
import 'package:hi_society_device/views/delivery/verify_ppl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/button.dart';
import '../../component/page_navigation.dart';
import '../../theme/colors.dart';
import '../../theme/padding_margin.dart';
import '../../theme/text_style.dart';

class ScanPPLQR extends StatefulWidget {
  const ScanPPLQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPPLQRState();
}

class _ScanPPLQRState extends State<ScanPPLQR> {
  //Variables
  Barcode? result;
  bool isBN = false;
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
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
      if (result != null) {
        controller.stopCamera();
        controller.dispose();
        routeNoBack(context, VerifyPPL(gatePassCode: result!.code.toString()));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  defaultInit() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => isBN = pref.getBool("isBN") ?? false);
    await Future.delayed(Duration(milliseconds: 100));
    flipCamera();
  }

  flipCamera() => controller?.flipCamera();

  //Initiate
  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
    defaultInit();
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
                  Text(i18n_rcvParcelQrLine1(isBN), style: semiBold14White, textAlign: TextAlign.center),
                  Text(i18n_rcvParcelQrLine2(isBN), style: semiBold14White, textAlign: TextAlign.center),
                  Text(i18n_rcvParcelQrLine3(isBN), style: bold22White)
                ]))
          ])),
          Padding(
              padding: primaryPadding * 2,
              child: Column(children: [
                Padding(padding: EdgeInsets.only(bottom: primaryPaddingValue), child: Text((result != null) ? i18n_qrFound(isBN) : i18n_qrTrouble(isBN), textAlign: TextAlign.center, style: normal14Black)),
                (result != null)
                    ? primaryButton(
                        context: context,
                        title: i18n_submit(isBN),
                        onTap: () async {
                          await controller?.pauseCamera();
                          await controller?.stopCamera();
                          routeNoBack(context, VerifyPPL(gatePassCode: result!.code.toString()));
                        })
                    : Row(
                        children: [
                          Expanded(
                              child: primaryButton(
                                  context: context,
                                  primary: false,
                                  title: i18n_typeManually(isBN),
                                  onTap: () async {
                                    routeBack(context);
                                    await controller?.pauseCamera();
                                    await controller?.stopCamera();
                                  })),
                          SizedBox(width: primaryPaddingValue / 2),
                          SizedBox(width: 64, child: primaryButtonIconOnly(context: context, primary: false, icon: Icons.flip_camera_ios_rounded, onTap: flipCamera)),
                        ],
                      )
              ]))
        ]));
  }
}

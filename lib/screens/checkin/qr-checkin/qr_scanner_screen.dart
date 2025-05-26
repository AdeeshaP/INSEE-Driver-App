import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/models/verification_type.dart';
import 'package:insee_driver_app/screens/checkin/face-verify-checkin/verify_result.dart';
import 'package:insee_driver_app/screens/checkin/qr-checkin/error_checkin_screen.dart';
import 'package:insee_driver_app/screens/home/dashboard.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({
    Key? key,
    required this.driverCode,
    // required this.validQRCodes,
  }) : super(key: key);
  final String driverCode;
  // final List<String> validQRCodes;

  @override
  State<StatefulWidget> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isProcessing = false;
  List<String> qrValuesList = [];
  String qr = "B1234567";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    // qrValuesList = List.from(widget.validQRCodes); 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "QR Code Verification",
                    style: TextStyle(
                        fontSize: Responsive.isMobileSmall(context)
                            ? 25
                            : Responsive.isMobileMedium(context)
                                ? 30
                                : Responsive.isMobileLarge(context)
                                    ? 30
                                    : Responsive.isTabletPortrait(context)
                                        ? 35
                                        : 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.red[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Place the QR code in the area.",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black38,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Section description
            Expanded(
              flex: 1,
              child: Text(
                "Driver ID : ${widget.driverCode}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    height: 1.5,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 7,
              child: _buildQrView(context),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  result == null
                      ? "Scanned result : N/A "
                      : "Scanned result : ${result!.code}",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? MediaQuery.of(context).size.width
    //     : 300.0;

    return QRView(
      overlayMargin: EdgeInsets.all(0),
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          overlayColor: Colors.white,
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 20,
          cutOutSize: 350),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      // Avoid processing multiple scans while navigating
      if (_isProcessing || scanData.code == null) return;

      final scannedCode = scanData.code!;

      setState(() {
        result = scanData;
      });

      print("result is ${result!.code}");

      final isValid = _validateQRCode(result!.code!);

      print("isValid is ${isValid}");

      // Navigate to success or error screen based on validation
      if (isValid == true && result != null) {
        _isProcessing = true;
        controller.pauseCamera();
        _navigateToSuccessScreen(scannedCode);
      } else if (isValid == false && result != null) {
        _isProcessing = true;
        controller.pauseCamera();
        _navigateToErrorScreen(scannedCode);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  bool _validateQRCode(String scannedCode) {
    print("your scanned code is $scannedCode");

    // print(qrValuesList.contains(scannedCode.toString()));
    // return qrValuesList.contains(scannedCode);
    return qr == scannedCode;
  }

  void _navigateToSuccessScreen(String code) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => VerificationResultScreen(
        isSuccess: true,
        onContinue: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(driverCode: widget.driverCode),
            ),
          );
        },
        onAlternativeVerification: (VerificationType type) {
          // Handle alternative verification methods
        },
        driverCode: widget.driverCode,
        recognitionType: "QR",
      ),
    ));
  }

  void _navigateToErrorScreen(String code) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ErrorCheckInScreen(
          qrCode: code,
          driverCode: widget.driverCode,
        ),
      ),
    );
  }
}

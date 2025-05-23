
import 'package:flutter/material.dart';
import 'package:insee_driver_app/constants/constants.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/models/verification_type.dart';
import 'package:insee_driver_app/screens/checkin/face-verify-checkin/code_verify.dart';

class VerificationResultScreen extends StatefulWidget {
  final bool isSuccess;
  final String recognitionType;
  final VoidCallback onContinue;
  final Function(VerificationType) onAlternativeVerification;
  final String driverCode;

  const VerificationResultScreen({
    Key? key,
    required this.isSuccess,
    required this.onContinue,
    required this.onAlternativeVerification,
    required this.driverCode,
    required this.recognitionType,
  }) : super(key: key);

  @override
  State<VerificationResultScreen> createState() =>
      _VerificationResultScreenState();
}

class _VerificationResultScreenState extends State<VerificationResultScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: widget.isSuccess ? size.height * 0.75 : size.height * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isSuccess ? "Access Allowed." : "Access Denied.",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // Icon - Success tick or failure cross
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSuccess ? Colors.green : buttonColor,
                  ),
                  child: Icon(
                    widget.isSuccess ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                SizedBox(height: 25),

                // Message
                Text(
                  widget.recognitionType == "Face"
                      ? (widget.isSuccess
                          ? "Face verification successful!"
                          : "Face verification failed!")
                      : widget.recognitionType == "QR"
                          ? (widget.isSuccess
                              ? "QR verification successful!"
                              : "QR verification failed!")
                          : widget.recognitionType == "Fingerprint"
                              ? (widget.isSuccess
                                  ? "Fingerprint verification successful!"
                                  : "Fingerprint verification failed!")
                              : "Unknown verification type",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                Text(
                  widget.isSuccess
                      ? "You have been successfully verified and you can proceed."
                      : "Please try again or use an alternative verification method.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Buttons
                if (widget.isSuccess)
                  ElevatedButton(
                    onPressed: widget.onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fixedSize: Responsive.isMobileSmall(context)
                          ? Size(size.width, 45)
                          : Responsive.isMobileMedium(context) ||
                                  Responsive.isMobileLarge(context)
                              ? Size(size.width, 50)
                              : Responsive.isTabletPortrait(context)
                                  ? Size(size.width, 55)
                                  : Size(size.width, 60),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  )
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CodeVerificationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fixedSize: Responsive.isMobileSmall(context)
                              ? Size(size.width, 45)
                              : Responsive.isMobileMedium(context) ||
                                      Responsive.isMobileLarge(context)
                                  ? Size(size.width, 50)
                                  : Responsive.isTabletPortrait(context)
                                      ? Size(size.width, 55)
                                      : Size(size.width, 60),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 25,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                "Go Back and Try Again",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                       
                        onPressed: () {
                       
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fixedSize: Responsive.isMobileSmall(context)
                              ? Size(size.width, 45)
                              : Responsive.isMobileMedium(context) ||
                                      Responsive.isMobileLarge(context)
                                  ? Size(size.width, 50)
                                  : Responsive.isTabletPortrait(context)
                                      ? Size(size.width, 55)
                                      : Size(size.width, 60),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(
                                Icons.qr_code,
                                color: Colors.white,
                                size: 25,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                "Verify with QR Code",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
        
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

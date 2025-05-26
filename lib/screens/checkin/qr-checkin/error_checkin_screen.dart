// Error Screen
import 'package:flutter/material.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/screens/checkin/qr-checkin/qr_scanner_screen.dart';
import 'package:insee_driver_app/screens/options_screen.dart';

class ErrorCheckInScreen extends StatelessWidget {
  final String qrCode;
  final String driverCode;

  const ErrorCheckInScreen(
      {Key? key, required this.qrCode, required this.driverCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Access Denied.",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              SizedBox(height: 32),

              // Error message
              Text(
                'QR Verification Failed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'The QR code is invalid or has expired.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: Responsive.isMobileSmall(context)
                      ? Size(size.width, 50)
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? Size(size.width, 55)
                          : Responsive.isTabletPortrait(context)
                              ? Size(size.width, 60)
                              : Size(size.width, 60),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrScannerScreen(
                        driverCode: driverCode,
                        // validQRCodes: ['B1234567', 'CHECK-123', 'EVENT-456'],
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.replay,
                        color: Colors.white,
                        size: 25,
                      ),
                      flex: 6,
                    ),
                    Expanded(
                        flex: 8,
                        child: Text(
                          'Try Again',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Try again button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: Responsive.isMobileSmall(context)
                      ? Size(size.width, 50)
                      : Responsive.isMobileMedium(context) ||
                              Responsive.isMobileLarge(context)
                          ? Size(size.width, 55)
                          : Responsive.isTabletPortrait(context)
                              ? Size(size.width, 60)
                              : Size(size.width, 60),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OptionsScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                      flex: 6,
                    ),
                    Expanded(
                        flex: 8,
                        child: Text(
                          'Go Back to Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

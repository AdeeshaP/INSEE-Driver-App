import 'package:flutter/material.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';

class EnrollSuccessScreen extends StatefulWidget {
  // final bool isSuccess;
  // final String recognitionType;
  // final VoidCallback onContinue;
  // final Function(VerificationType) onAlternativeVerification;
  final String driverCode;

  const EnrollSuccessScreen({
    Key? key,
    // required this.isSuccess,
    // required this.onContinue,
    // required this.onAlternativeVerification,
    required this.driverCode,
    // required this.recognitionType,
  }) : super(key: key);

  @override
  State<EnrollSuccessScreen> createState() => _EnrollSuccessScreenState();
}

class _EnrollSuccessScreenState extends State<EnrollSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: size.height * 0.8,
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enrollment Successful!",
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
                    color: Colors.green,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                SizedBox(height: 25),

                // // Message
                // Text(
                //   "Enrollment successful!",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(height: 16),

                Text(
                  "You have been successfully enrolled to the system and you can access to the system.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Buttons
                ElevatedButton(
                  onPressed: () {},
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

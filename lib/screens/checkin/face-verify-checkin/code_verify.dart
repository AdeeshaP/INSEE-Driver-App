import 'package:flutter/material.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';

class CodeVerificationScreen extends StatefulWidget {
  CodeVerificationScreen({Key? key}) : super(key: key);

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  void _validateDriverCode() {
    String driverCode = _codeController.text.trim();

    if (formkey.currentState!.validate()) {
      if (driverCode.isNotEmpty) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),

                // Logo section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/eagle.png',
                      width: Responsive.isMobileSmall(context) ? 120 : 120,
                      height: Responsive.isMobileSmall(context) ? 75 : 120,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Title text
                Text(
                  "Welcome to INSEE \nDelivery Management System",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030),
                  ),
                ),

                SizedBox(height: 50),

                // Verification card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 20,
                        blurRadius: 20,
                        offset: Offset(1, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Text(
                        "Code Verification",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF303030),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Section description
                      Text(
                        "Enter the verification code linked to your driver record to proceed to the enrollment screen.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF757575),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(height: 30),

                      // Input field
                      Form(
                        key: formkey,
                        child: TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: "Enter the driving license no",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  // color: Color(0xFF1565C0), width: 1.5),
                                  color: Colors.black54,
                                  width: 1.2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  // color: Color(0xFF1565C0), width: 1.5),
                                  color: const Color.fromARGB(255, 194, 17, 4),
                                  width: 1.2),
                            ),
                            prefixIcon: Icon(
                              Icons.vpn_key_rounded,
                              color: Color.fromARGB(255, 228, 50, 6),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your license number';
                            } else if (value.length < 8) {
                              return 'This is too short. License Number contains \nat least 8 characters.';
                            } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                                .hasMatch(value)) {
                              return 'Only letters and numbers are allowed';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Submit button
                      ElevatedButton(
                        onPressed: _validateDriverCode,
                        style: ElevatedButton.styleFrom(
                          fixedSize: Responsive.isMobileSmall(context)
                              ? Size(size.width, 50)
                              : Responsive.isMobileMedium(context) ||
                                      Responsive.isMobileLarge(context)
                                  ? Size(size.width, 55)
                                  : Responsive.isTabletPortrait(context)
                                      ? Size(size.width, 60)
                                      : Size(size.width, 60),
                          backgroundColor: Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

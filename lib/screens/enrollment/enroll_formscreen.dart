import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insee_driver_app/constants/constants.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'dart:io';
import 'package:signature/signature.dart';
import 'package:insee_driver_app/screens/enrollment/enroll_success.dart';
import 'package:image_picker/image_picker.dart';

class DriverEnrollmentScreen extends StatefulWidget {
  @override
  _DriverEnrollmentScreenState createState() => _DriverEnrollmentScreenState();
}

class _DriverEnrollmentScreenState extends State<DriverEnrollmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhotoCaptured = false;
  bool _isSignTaken = false;
  File? _capturedImage;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );
  Uint8List? _signatureImage;

  void _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
        _isPhotoCaptured = true; // Enable the Enroll button
      });
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
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // INSEE Logo
                SizedBox(height: 20),
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
                      width: 140,
                      height: Responsive.isMobileSmall(context) ? 75 : 90,
                    ),
                  ),
                ),

                SizedBox(height: 24),
                // Screen Title
                Text(
                  'Driver Enrollment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name Input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black38,
                          ),
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.black54),
                          fillColor: Colors.grey[100],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 216, 16, 2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 1, 10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Driving License Input
                      TextFormField(
                        controller: _licenseController,
                        decoration: InputDecoration(
                          // hintText: 'Driving License Number',
                          prefixIcon: Icon(
                            Icons.add_card_sharp,
                            color: Colors.black38,
                          ),
                          labelText: 'Driving License Number',
                          labelStyle: TextStyle(color: Colors.black54),
                          fillColor: Colors.grey[100],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 216, 16, 2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 1, 10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your driving license number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Phone Number Input
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black38,
                          ),
                          labelStyle: TextStyle(color: Colors.black54),
                          labelText: 'Phone Number',
                          fillColor: Colors.grey[100],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 216, 16, 2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 0, 1, 10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: Text(
                                "Capture Your Face",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Expanded(
                            flex: 6,
                            child: ElevatedButton.icon(
                              onPressed: _takePicture,
                              icon: Icon(
                                _capturedImage == null
                                    ? Icons.camera_alt
                                    : Icons.check_circle,
                                color: _capturedImage == null
                                    // ? Colors.black26
                                    ? Colors.white
                                    : Colors.white,
                                size: 25,
                              ),
                              label: Text(
                                _capturedImage == null
                                    ? 'Take Photo'
                                    : "Photo Captured",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _capturedImage == null
                                      // ? Colors.black38
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _capturedImage == null
                                    ? buttonColor
                                    // ? Colors.grey[100]
                                    : Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _capturedImage == null ? 4 : 12),

                      _capturedImage != null
                          ? Container(
                              // width: 150,
                              height: 150,
                              // decoration: BoxDecoration(
                              //   color: Colors.grey[100],
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              child: Image.file(_capturedImage!,
                                  fit: BoxFit.contain),
                            )
                          : Text(
                              'No face captured',
                              style: TextStyle(color: Colors.grey),
                            ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: Text(
                                "Add Your Signature",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Expanded(
                            flex: 6,
                            child: ElevatedButton.icon(
                              onPressed: _showSignatureDialog,
                              icon: Icon(
                                _signatureImage == null
                                    ? Icons.edit
                                    : Icons.check_circle,
                                color: _signatureImage == null
                                    // ? Colors.black38
                                    ? Colors.white
                                    : Colors.white,
                                size: 25,
                              ),
                              label: Text(
                                  _signatureImage == null
                                      ? 'Add Signature'
                                      : "Signature Added",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _signatureImage == null
                                        // ? Colors.black38
                                        ? Colors.white
                                        : Colors.white,
                                  )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _signatureImage == null
                                    // ? Colors.grey[100]
                                    ? buttonColor
                                    : Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _signatureImage == null ? 4 : 12),

                      _signatureImage != null
                          ? Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.memory(_signatureImage!),
                            )
                          : Text(
                              'No signature captured',
                              style: TextStyle(color: Colors.grey),
                            ),
                      // Face Capture Section
                      // Text(
                      //   'Capture Your Face',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.black87,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(height: 16),

                      // Face Capture Button and Preview
                      // Center(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         width: double.infinity,
                      //         child: ElevatedButton.icon(
                      //           onPressed: _takePicture,
                      //           icon: Icon(
                      //             Icons.camera_alt,
                      //             color: Colors.white,
                      //             size: 25,
                      //           ),
                      //           label: Text('Take Photo',
                      //               style: TextStyle(fontSize: 16)),
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Color(0xFFD32F2F),
                      //             foregroundColor: Colors.white,
                      //             padding: EdgeInsets.symmetric(vertical: 16),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 16),
                      //       _capturedImage != null
                      //           ? Container(
                      //               width: 150,
                      //               height: 150,
                      //               decoration: BoxDecoration(
                      //                 color: Colors.grey[100],
                      //                 borderRadius: BorderRadius.circular(8),
                      //               ),
                      //               child: Image.file(_capturedImage!,
                      //                   fit: BoxFit.cover),
                      //             )
                      //           : Text(
                      //               'No face captured',
                      //               style: TextStyle(color: Colors.grey),
                      //             ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 20),

                      // Singature Capture Section
                      // Text(
                      //   'Add Your Signature',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.black87,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(height: 16),
                      // Face Capture Button and Preview
                      // Center(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         width: double.infinity,
                      //         child: ElevatedButton.icon(
                      //           onPressed: _showSignatureDialog,
                      //           icon: Icon(
                      //             Icons.edit,
                      //             color: Colors.white,
                      //             size: 25,
                      //           ),
                      //           label: Text('Add Signature',
                      //               style: TextStyle(fontSize: 16)),
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Color(0xFFD32F2F),
                      //             foregroundColor: Colors.white,
                      //             padding: EdgeInsets.symmetric(vertical: 16),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 16),
                      //       _signatureImage != null
                      //           ? Text(
                      //               _signatureFileName,
                      //               style: TextStyle(
                      //                   fontSize: 14, color: Colors.black),
                      //             )
                      //           : Text(
                      //               'No signature captured',
                      //               style: TextStyle(color: Colors.grey),
                      //             ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 20),

                      // Enroll Button
                      ElevatedButton(
                        onPressed: () {
                          if (_capturedImage == null ||
                              _isPhotoCaptured == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please capture your photo and add your signature')),
                            );
                            return;
                          } else if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnrollSuccessScreen(
                                    driverCode: _licenseController.text),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Enroll Driver',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPhotoCaptured &&
                                  _isSignTaken &&
                                  _formKey.currentState!.validate()
                              ? Color(0xFFE53935)
                              : const Color.fromARGB(255, 213, 213, 213),
                          foregroundColor: Colors.white,
                          fixedSize: Size(size.width, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            // side: BorderSide(color: Colors.grey),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignatureDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  Add Signature',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: StatefulBuilder(
                builder: (context, _setState) => Column(
                  children: [
                    Column(
                      children: [
                        Signature(
                          controller: _signatureController,
                          height: 220,
                          backgroundColor: Colors.grey[200]!,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _signatureController.clear(),
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                minimumSize: Size(110, 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_signatureController.isNotEmpty) {
                                  var image =
                                      await _signatureController.toImage();
                                  var byteData = await image!
                                      .toByteData(format: ImageByteFormat.png);
                                  var imageBytes =
                                      byteData!.buffer.asUint8List();

                                  var fileName =
                                      'signature_${DateTime.now().millisecondsSinceEpoch}.jpg';

                                  // String base64String5 =
                                  //     base64Encode(imageBytes);

                                  // Save image and filename
                                  setState(() {
                                    _signatureImage = imageBytes;
                                    // _signatureFileName = fileName;
                                    // _signatureBase64 = base64String5;
                                    _isSignTaken = true;
                                  });

                                  print("file name is $fileName");
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Please add a signature.')),
                                  );
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                minimumSize: Size(110, 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // },
    // );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insee_driver_app/models/verification_type.dart';
import 'package:insee_driver_app/screens/checkin/face-verify-checkin/verify_result.dart';
import 'package:insee_driver_app/screens/home/dashboard.dart';
import 'package:camera/camera.dart';
import 'package:local_auth/local_auth.dart';

class FaceVerificationScreen extends StatefulWidget {
  final String driverCode;

  const FaceVerificationScreen({Key? key, required this.driverCode})
      : super(key: key);

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  RegExp regex = new RegExp(r'^.{3,}$');
  var localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _verifyFace() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      _showLoadingDialog();

      final XFile capturedImage = await _cameraController!.takePicture();

      bool isVerificationSuccessful = await _performFaceVerification(
          driverCode: widget.driverCode, imagePath: capturedImage.path);

      Navigator.of(context).pop();

      // Navigate to verification result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationResultScreen(
            isSuccess: isVerificationSuccessful,
            onContinue: () {
              if (isVerificationSuccessful) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen(driverCode: widget.driverCode),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
            onAlternativeVerification: (VerificationType type) {
            },
            driverCode: widget.driverCode,
            recognitionType: "Face",
          ),
        ),
      );
    } catch (e) {
      print('Face verification error: $e');
      // Dismiss loading dialog if showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showVerificationFailedDialog();
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                color: Color(0xFFDE2B26).withOpacity(0.7),
              ),
              SizedBox(width: 20),
              Text("Verifying..."),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _performFaceVerification(
      {required String driverCode, required String imagePath}) async {
    final bool simulateSuccess = widget.driverCode == "B1234567" ? true : false;

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    return simulateSuccess;
  }

  void _showVerificationFailedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Verification Failed'),
        content: Text('Face verification unsuccessful. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Optionally, reset to driver code screen
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with INSEE logo
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/eagle.png',
                      height: 80,
                      color: Color(0xFFD32F2F),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Face Verification',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Face Verification Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Please position your face within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),

            // Camera Preview Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                // child: Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Color(0xFFD32F2F),
                //       width: 3,
                //     ),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(12),
                //     child: _isCameraInitialized
                //       ? CameraPreview(_cameraController!)
                //       : Center(
                //           child: CircularProgressIndicator(
                //             color: Color(0xFFD32F2F),
                //           ),
                //         ),
                //   ),

                // ),
                child: Container(
                  width: size.width,
                  height: size.height * 0.5,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFD32F2F),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: size.width,
                      height: size.height * 0.5,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _isCameraInitialized
                            ? CameraPreview(_cameraController!)
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Verify Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ElevatedButton(
                onPressed: _verifyFace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Verify Face',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

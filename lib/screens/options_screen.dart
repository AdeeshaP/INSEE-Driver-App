import 'package:flutter/material.dart';
import 'package:insee_driver_app/screens/checkin/face-verify-checkin/code_verify.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade300, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // INSEE Logo and Title Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/INSEE-Logo-2.png',
                      height: 120,
                      width: 300,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "INSEE",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Welcome to INSEE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Delivery Management System',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),

              // Main content - the two options
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 36),
                  child: Row(
                    children: [
                      // Check-in Option
                      Expanded(
                        child: _buildOptionCard(
                          context,
                          icon: Icons.login,
                          title: 'Check-in',
                          description:
                              'Verify your entry to the factory premises',
                          color: Colors.red.shade600,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CodeVerificationScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      // Enroll Option
                      Expanded(
                        child: _buildOptionCard(
                          context,
                          icon: Icons.app_registration,
                          title: 'Enroll',
                          description: 'New registration for factory access',
                          color: Colors.red.shade800,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with version info
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Version 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Powered by Auradot (Pvt) Ltd.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              SizedBox(height: 24),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

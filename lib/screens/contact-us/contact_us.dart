
import 'package:flutter/material.dart';
import 'package:insee_driver_app/constants/constants.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/screens/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<String> _menuOptions = [
    'Settings',
    'Contact Us',
  ];

  // --------- Side Menu Bar Navigation ---------- //
  void choiceAction(String choice) {
    if (choice == _menuOptions[0]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return SettingsScreen();
        }),
      );
    } else if (choice == _menuOptions[1]) {}
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _makeHotLineCall() async {
    String phoneNumber = "+94 112 233 233";
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri, mode: LaunchMode.externalNonBrowserApplication);
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ccontact@auradot.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Add Subject',
        'body': 'Write something...!',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/eagle.png',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.red.shade200,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 40,
            child: Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.white,
              ),
              child: PopupMenuButton<String>(
                iconColor: Colors.red.shade400,
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return _menuOptions.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice,
                          style: TextStyle(
                            fontSize: Responsive.isMobileSmall(context) ||
                                    Responsive.isMobileMedium(context) ||
                                    Responsive.isMobileLarge(context)
                                ? size.width * 0.044
                                : Responsive.isTabletPortrait(context)
                                    ? size.width * 0.03
                                    : size.width * 0.02,
                          ),
                          textScaler: TextScaler.linear(1)),
                    );
                  }).toList();
                },
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // INSEE Logo
                Image.asset(
                  'assets/images/INSEE-Logo.png',
                  height: 180,
                ),

                // Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration('Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Message Input
                TextFormField(
                  controller: _messageController,
                  decoration: _inputDecoration('Your Message'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Contact Information
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Customer Support',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: (){
                          _makeHotLineCall();
                        },
                        child: Text(
                          'Phone: +94 112 233 233',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _sendEmail();
                        },
                        child: Text(
                          'Email: support@inseecement.com',
                          style: TextStyle(color: Colors.black87),
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

  // Input Decoration Helper Method
  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
    );
  }

  // Form Submission Method
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form after submission
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

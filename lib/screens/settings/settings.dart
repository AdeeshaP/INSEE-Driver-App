import 'package:flutter/material.dart';
import 'package:insee_driver_app/dimensions/responsive.dart';
import 'package:insee_driver_app/screens/contact-us/contact_us.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Theme toggle
  bool isNotificationsEnabled = true; // Notifications toggle
  String selectedLanguage = 'English'; // Default language

  // Side Menu Bar Options
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
    } else if (choice == _menuOptions[1]) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ContactUsScreen();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/eagle.png',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Settings",
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
      body: Container(
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            SizedBox(height: 50),
            // Theme Toggle
            ListTile(
              leading: Icon(
                Icons.brightness_6,
                color: Colors.black,
              ),
              title: Text('Dark Mode',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Switch(
                activeColor: Colors.black,
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    // Dynamically toggle between themes
                    isDarkMode
                        ? Theme.of(context)
                            .copyWith(brightness: Brightness.dark)
                        : Theme.of(context)
                            .copyWith(brightness: Brightness.light);
                  });
                  // Change app theme dynamically (if needed)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Theme changed to ${isDarkMode ? "Dark" : "Light"}'),
                    ),
                  );
                },
              ),
            ),
            Divider(),

            // Notifications Toggle
            // ListTile(
            //   leading: Icon(Icons.notifications),
            //   title: Text('Enable Notifications'),
            //   trailing: Switch(
            //     value: isNotificationsEnabled,
            //     onChanged: (value) {
            //       setState(() {
            //         isNotificationsEnabled = value;
            //       });
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(
            //               'Notifications ${isNotificationsEnabled ? "enabled" : "disabled"}'),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // Divider(),

            // Language Selection
            ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.black,
              ),
              title: Text('App Language',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              subtitle: Text(selectedLanguage,
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {
                _showLanguageDialog();
              },
            ),
            Divider(),

            // Other Settings Placeholder
            ListTile(
              leading: Icon(
                Icons.security,
                color: Colors.black,
              ),
              title: Text('Privacy Settings',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {
                // Navigate to Privacy Settings (Add your logic here)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Privacy Settings clicked')),
                );
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text('About App',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Navigate to About App (Add your logic here)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('About App clicked')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show Dialog for Language Selection
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              children: ['English', 'Spanish', 'French', 'German']
                  .map(
                    (language) => RadioListTile(
                      title: Text(language),
                      value: language,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                        Navigator.pop(context); // Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Language changed to $value')),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

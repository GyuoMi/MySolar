import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80), // Add a buffer of 80 from the top
      child: Align(
        alignment: Alignment.topLeft, // Align with the top-left of the screen
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 250,
              maxWidth: 150), // Adjust the height and width as needed
          child: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () {
                    // Handle the Settings click
                    Navigator.of(context).pushReplacementNamed('/settings');
                  },
                ),
                ListTile(
                  title: Text('Devices'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/devices');
                  },
                ),
                ListTile(
                  title: Text('Tracking'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/tracking');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

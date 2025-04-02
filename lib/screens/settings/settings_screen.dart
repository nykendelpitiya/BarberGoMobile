import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Privacy"),
            onTap: () {
              // Navigate to Privacy Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {
              // Navigate to Notification Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            onTap: () {
              // Navigate to Language Settings
            },
          ),
        ],
      ),
    );
  }
}

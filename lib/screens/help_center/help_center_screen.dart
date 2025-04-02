import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  static String routeName = "/help_center";

  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text("Q: How do I reset my password?"),
          Text("A: Go to the Forgot Password screen and follow the steps."),
          SizedBox(height: 16),
          Text("Q: How do I contact support?"),
          Text("A: Email us at support@example.com."),
        ],
      ),
    );
  }
}

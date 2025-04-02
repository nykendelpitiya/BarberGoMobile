import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../help_center/help_center_screen.dart';
import 'my_account_screen.dart';
import '../settings/settings_screen.dart';
import '../splash/splash_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () {
                Navigator.pushNamed(context, MyAccountScreen.routeName);
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Navigator.pushNamed(context, HelpCenterScreen.routeName);
              },
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ProfileMenu(
                  text: authProvider.isLoading ? "Logging out..." : "Log Out",
                  icon: "assets/icons/Log out.svg",
                  press: authProvider.isLoading
                      ? null
                      : () {
                          showLogoutConfirmationDialog(context);
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Function to show a confirmation dialog before logging out
  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text("Log Out"),
              onPressed: () async {
                Navigator.of(context).pop(); 
                
                try {
                  // Sign out using AuthProvider
                  await context.read<AuthProvider>().signOut();
                  
                  // Clear navigation stack and go to splash screen
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashScreen.routeName,
                      (Route<dynamic> route) => false, 
                    );
                  }
                } catch (e) {
                  // Show error if logout fails
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Logout failed: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
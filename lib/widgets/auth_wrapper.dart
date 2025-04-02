import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/init_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/admin/admin_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  static String routeName = "auth_wrapper";

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading indicator while initial authentication state is being determined
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If not authenticated, show the login screen
        if (!authProvider.isAuthenticated) {
          return const SplashScreen();
        }
        
        // If authenticated but email not verified
        if (!authProvider.isEmailVerified) {
          return const EmailVerificationScreen();
        }

        // If authenticated and email verified, check role
        // Use FutureBuilder to wait for role verification
        return FutureBuilder<bool>(
          future: authProvider.verifyAdminRole(),
          builder: (context, snapshot) {
            // Show loading indicator while role is being determined
            if (snapshot.connectionState == ConnectionState.waiting || authProvider.isRoleLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // If admin, show admin screen
            if (snapshot.hasData && snapshot.data == true) {
              return const AdminScreen();
            }
            
            // Otherwise, show regular user screen
            return const InitScreen();
          },
        );
      },
    );
  }
}

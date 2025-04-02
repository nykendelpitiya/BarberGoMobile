import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../init_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  static String routeName = "/email-verification";
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _isResendEnabled = true;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Cancel any existing timer
    _timer?.cancel();
    
    // Start periodic check
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) {
        _timer?.cancel();
        return;
      }

      final isEmailVerified = await authProvider.checkEmailVerified();
      
      if (isEmailVerified) {
        _timer?.cancel();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(InitScreen.routeName);
        }
      }
    });
  }

  void _startResendCooldown() {
    setState(() {
      _isResendEnabled = false;
      _resendCooldown = 30;
    });

    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_resendCooldown == 0) {
          setState(() {
            _isResendEnabled = true;
          });
          timer.cancel();
        } else {
          setState(() {
            _resendCooldown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'We\'ve sent a verification email to ${context.read<AuthProvider>().user?.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Click the link in the email to verify your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isResendEnabled
                  ? () {
                    debugPrint('Resending email verification...');
                      context.read<AuthProvider>().sendEmailVerification();
                      _startResendCooldown();
                    }
                  : null,
              child: Text(_isResendEnabled
                  ? 'Resend Email'
                  : 'Resend in $_resendCooldown seconds'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => context.read<AuthProvider>().checkEmailVerified(),
              child: const Text('I have verified my email'),
            ),
          ],
        ),
      ),
    );
  }
}

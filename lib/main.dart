import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbergo/providers/cart_provider.dart';
import 'package:barbergo/routes.dart';
import 'package:barbergo/providers/auth_provider.dart';
import 'package:barbergo/providers/booking_provider.dart';
import 'theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The BarberGo - Mobile App',
      theme: AppTheme.lightTheme(context),
      initialRoute: AuthWrapper.routeName,
      routes: routes,
    );
  }
}
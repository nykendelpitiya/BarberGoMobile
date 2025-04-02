import 'package:flutter/widgets.dart';
import 'package:barbergo/screens/auth/email_verification_screen.dart';
import 'package:barbergo/screens/products/products_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'screens/booking/booking_history_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/help_center/help_center_screen.dart';
import 'screens/booking/booking.dart';
import 'screens/game_deal/game_deal_screen.dart';
import 'screens/daily_gift_deal/daily_gift_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/Grooming/Grooming_items.dart';
import 'screens/profile/my_account_screen.dart';
import 'screens/booking/booking_form_screen.dart';

// Define all routes in one place
final Map<String, WidgetBuilder> routes = {
  AuthWrapper.routeName: (context) => const AuthWrapper(),
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),

  SettingsScreen.routeName: (context) => const SettingsScreen(),
  HelpCenterScreen.routeName: (context) => const HelpCenterScreen(),
  SalonBookingScreen.routeName: (context) => const SalonBookingScreen(),
  GameDealScreen.routeName: (context) => GameDealScreen(),
  SalonDailyOffersScreen.routeName: (context) => const SalonDailyOffersScreen(),
  EmailVerificationScreen.routeName: (context) => const EmailVerificationScreen(),
  GroomingItemsPage.routeName:(context) => GroomingItemsPage(),
  AdminScreen.routeName: (context) => const AdminScreen(),
  BookingHistoryScreen.routeName: (context) => const BookingHistoryScreen(),
  MyAccountScreen.routeName: (context) => const MyAccountScreen(),
  BookingFormScreen.routeName: (context) => const BookingFormScreen(),
};
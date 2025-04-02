import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;
  bool _isRoleLoading = true;
  bool _isEmailVerified = false;
  bool _isLoggingOut = false; // Add flag for logout state

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      _isEmailVerified = user?.emailVerified ?? false;
      _isLoading = true;
      _isRoleLoading = true;
      notifyListeners();
      
      if (user != null) {
        await _reloadUserData();
      } else {
        _userModel = null;
        _isLoading = false;
        _isRoleLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _reloadUserData() async {
    if (_user != null) {
      try {
        _userModel = await _firestoreService.getUser(_user!.uid);
        _isRoleLoading = false;
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading user data: $e');
        _isRoleLoading = false;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading || _isLoggingOut; // Consider both loading states
  bool get isRoleLoading => _isRoleLoading;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _isEmailVerified;
  bool get isAdmin => _userModel?.role == 'admin';
  
  Future<bool> verifyAdminRole() async {
    if (_isRoleLoading) {
      await Future.doWhile(() => _isRoleLoading);
    }
    return isAdmin;
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _reloadUserData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, {bool isAdmin = false}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final userCredential = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          role: isAdmin ? 'admin' : 'user',
          profile: {},
        );
        await _firestoreService.createUser(userModel);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (_isLoggingOut) return; // Prevent multiple calls
    
    try {
      _isLoggingOut = true; // Set specific logout flag
      notifyListeners();
      
      // Add a small delay to ensure UI updates before Firebase completes signout
      await Future.delayed(const Duration(milliseconds: 100));
      await _authService.signOut();
      
      // Return a completed future
      return Future.value();
    } catch (e) {
      debugPrint('Error signing out: $e');
      return Future.error(e);
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.sendEmailVerification();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _user?.reload();
      _isEmailVerified = _user?.emailVerified ?? false;
      return _isEmailVerified;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profile) async {
    if (_user != null) {
      await _firestoreService.updateUserProfile(_user!.uid, profile);
      _userModel = _userModel?.copyWith(profile: profile);
      notifyListeners();
    }
  }
}
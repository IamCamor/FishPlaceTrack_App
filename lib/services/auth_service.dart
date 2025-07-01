import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/user_provider.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _currentUser;
  String? _token;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _token != null;
  firebase_auth.User? get firebaseUser => _firebaseAuth.currentUser;

  // Initialize auth service
  Future<void> initialize() async {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? user) async {
      if (user != null) {
        await _handleUserSignIn(user);
      } else {
        await _handleUserSignOut();
      }
    });

    // Check if user is already signed in
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _handleUserSignIn(firebaseUser);
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    if (_token != null) return _token;
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Store token
  Future<void> _storeToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear token
  Future<void> _clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Handle user sign in
  Future<void> _handleUserSignIn(firebase_auth.User firebaseUser) async {
    try {
      // Get Firebase ID token
      final idToken = await firebaseUser.getIdToken();
      await _storeToken(idToken);

      // Get user profile from API
      try {
        _currentUser = await ApiService().getCurrentUser();
      } catch (e) {
        // If user doesn't exist in our database, create profile
        if (e is ApiException && e.code == '404') {
          await _createUserProfile(firebaseUser);
          _currentUser = await ApiService().getCurrentUser();
        } else {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('Error handling user sign in: $e');
      await logout();
    }
  }

  // Handle user sign out
  Future<void> _handleUserSignOut() async {
    _currentUser = null;
    await _clearToken();
  }

  // Create user profile in our database
  Future<void> _createUserProfile(firebase_auth.User firebaseUser) async {
    final userData = {
      'firebase_uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'display_name': firebaseUser.displayName,
      'photo_url': firebaseUser.photoURL,
      'phone_number': firebaseUser.phoneNumber,
      'email_verified': firebaseUser.emailVerified,
    };

    // Call API to create user profile
    await ApiService().updateProfile(userData);
  }

  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmail(String email, String password, {
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      return UserCredential._(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Email/Password Sign In
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserCredential._(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web implementation
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final credential = await _firebaseAuth.signInWithPopup(googleProvider);
        return UserCredential._(credential);
      } else {
        // Mobile implementation
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw AuthException('Google sign in was cancelled', code: 'cancelled');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        return UserCredential._(authResult);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    } catch (e) {
      throw AuthException(e.toString(), code: 'google_signin_error');
    }
  }

  // Apple Sign In (iOS/macOS/Web)
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final authResult = await _firebaseAuth.signInWithCredential(oauthCredential);
      return UserCredential._(authResult);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    } catch (e) {
      throw AuthException(e.toString(), code: 'apple_signin_error');
    }
  }

  // Anonymous Sign In (for guest users)
  Future<UserCredential> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return UserCredential._(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        await user.reload();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // First delete from our database
        // await ApiService().deleteAccount();
        
        // Then delete from Firebase
        await user.delete();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Reauthenticate user (required for sensitive operations)
  Future<void> reauthenticateWithEmail(String email, String password) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException._fromFirebaseException(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();
      
      // Clear local state
      await _handleUserSignOut();
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Force clear local state even if logout fails
      await _handleUserSignOut();
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    try {
      if (isAuthenticated) {
        _currentUser = await ApiService().getCurrentUser();
      }
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }
}

// Wrapper class for Firebase UserCredential
class UserCredential {
  final firebase_auth.UserCredential _credential;

  UserCredential._(this._credential);

  firebase_auth.User? get user => _credential.user;
  firebase_auth.AdditionalUserInfo? get additionalUserInfo => _credential.additionalUserInfo;
}

// Custom auth exception
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException(this.message, {required this.code});

  factory AuthException._fromFirebaseException(firebase_auth.FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'user-not-found':
        message = 'Пользователь с таким email не найден';
        break;
      case 'wrong-password':
        message = 'Неверный пароль';
        break;
      case 'email-already-in-use':
        message = 'Пользователь с таким email уже существует';
        break;
      case 'weak-password':
        message = 'Пароль слишком простой';
        break;
      case 'invalid-email':
        message = 'Неверный формат email';
        break;
      case 'user-disabled':
        message = 'Аккаунт заблокирован';
        break;
      case 'too-many-requests':
        message = 'Слишком много попыток. Попробуйте позже';
        break;
      case 'network-request-failed':
        message = 'Ошибка сети. Проверьте подключение к интернету';
        break;
      default:
        message = e.message ?? 'Произошла ошибка авторизации';
    }

    return AuthException(message, code: e.code);
  }

  @override
  String toString() => 'AuthException: $message (code: $code)';
}
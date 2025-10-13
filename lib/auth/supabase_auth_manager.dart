import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dental_roots/auth/auth_manager.dart';
import 'package:dental_roots/supabase/supabase_config.dart';
import 'package:dental_roots/models/user_profile.dart';

class SupabaseAuthManager extends AuthManager with EmailSignInManager {
  static final SupabaseAuthManager _instance = SupabaseAuthManager._();
  factory SupabaseAuthManager() => _instance;
  SupabaseAuthManager._();

  @override
  User? get currentUser => SupabaseConfig.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => SupabaseConfig.auth.onAuthStateChange;

  @override
  Future<User?> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      final response = await SupabaseConfig.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'An unexpected error occurred');
      }
      return null;
    }
  }

  @override
  Future<User?> createAccountWithEmail(BuildContext context, String email, String password) async {
    try {
      final response = await SupabaseConfig.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } on AuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'An unexpected error occurred');
      }
      return null;
    }
  }

  @override
  Future signOut() async {
    await SupabaseConfig.auth.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user logged in');
      
      await SupabaseConfig.client.rpc('delete_user');
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to delete account');
      }
    }
  }

  @override
  Future updateEmail({required String email, required BuildContext context}) async {
    try {
      await SupabaseConfig.auth.updateUser(UserAttributes(email: email));
      if (context.mounted) {
        _showSuccess(context, 'Email updated successfully');
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message);
      }
    }
  }

  @override
  Future resetPassword({required String email, required BuildContext context}) async {
    try {
      await SupabaseConfig.auth.resetPasswordForEmail(email);
      if (context.mounted) {
        _showSuccess(context, 'Password reset email sent');
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        _showError(context, e.message);
      }
    }
  }

  Future<void> createUserProfile({
    required String userId,
    required String clinicId,
    required String email,
    required String fullName,
    required UserRole role,
  }) async {
    final now = DateTime.now();
    await SupabaseService.insert('users', {
      'id': userId,
      'clinic_id': clinicId,
      'email': email,
      'full_name': fullName,
      'role': role.name,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    final data = await SupabaseService.selectSingle(
      'users',
      filters: {'id': userId},
    );
    return data != null ? UserProfile.fromJson(data) : null;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}

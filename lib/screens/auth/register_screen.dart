import 'package:flutter/material.dart';
import 'package:dental_roots/screens/dashboard/dashboard_screen.dart';
import 'package:dental_roots/screens/auth/login_screen.dart';
import 'package:dental_roots/auth/supabase_auth_manager.dart';
import 'package:dental_roots/models/user_profile.dart';
import 'package:dental_roots/supabase/supabase_config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _clinicNameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole _selectedRole = UserRole.dentist;
  String? _selectedClinicId;
  List<Map<String, dynamic>> _clinics = [];
  bool _isLoadingClinics = false;
  bool _createNewClinic = false;

  @override
  void initState() {
    super.initState();
    _loadClinics();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  Future<void> _loadClinics() async {
    setState(() => _isLoadingClinics = true);
    try {
      final clinics = await SupabaseService.select('clinics', orderBy: 'name');
      setState(() {
        _clinics = clinics;
        if (_clinics.isNotEmpty) {
          _selectedClinicId = _clinics.first['id'];
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load clinics: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoadingClinics = false);
    }
  }

  Future<String> _createClinic(String clinicName) async {
    final clinicData = {
      'name': clinicName.trim(),
      'address': 'To be updated',
      'phone': 'To be updated',
    };
    
    final result = await SupabaseService.insert('clinics', clinicData);
    return result.first['id'] as String;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String clinicId;
      
      // Handle clinic selection or creation
      if (_createNewClinic) {
        if (_clinicNameController.text.trim().isEmpty) {
          throw Exception('Please enter clinic name');
        }
        clinicId = await _createClinic(_clinicNameController.text);
      } else {
        if (_selectedClinicId == null) {
          throw Exception('Please select a clinic');
        }
        clinicId = _selectedClinicId!;
      }

      // Create user account
      final user = await SupabaseAuthManager().createAccountWithEmail(
        context,
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (user != null) {
        // Create user profile
        await SupabaseAuthManager().createUserProfile(
          userId: user.id,
          clinicId: clinicId,
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          role: _selectedRole,
        );

        if (mounted) {
          // Navigate to dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.dentist:
        return 'Dentist';
      case UserRole.assistant:
        return 'Dental Assistant';
      case UserRole.clerk:
        return 'Clerk';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.local_hospital_rounded, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 24),
                  Text('Create Account', style: theme.textTheme.displaySmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Join FLM Haiti EMR System now!', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)), textAlign: TextAlign.center),
                  const SizedBox(height: 48),
                  
                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter your full name';
                      if (value.trim().length < 2) return 'Name must be at least 2 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter password';
                      if (value.length < 8) return 'Password must be at least 8 characters';
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Password must contain uppercase, lowercase and number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Role Selection
                  DropdownButtonFormField<UserRole>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.work_outline, color: colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    items: UserRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(_getRoleDisplayName(role)),
                      );
                    }).toList(),
                    onChanged: (UserRole? newRole) {
                      if (newRole != null) {
                        setState(() => _selectedRole = newRole);
                      }
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a role';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Clinic Selection Toggle
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Existing Clinic'),
                          value: false,
                          groupValue: _createNewClinic,
                          onChanged: (value) => setState(() => _createNewClinic = value!),
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('New Clinic'),
                          value: true,
                          groupValue: _createNewClinic,
                          onChanged: (value) => setState(() => _createNewClinic = value!),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Clinic Selection/Creation
                  if (_createNewClinic) ...[
                    TextFormField(
                      controller: _clinicNameController,
                      decoration: InputDecoration(
                        labelText: 'Clinic Name',
                        prefixIcon: Icon(Icons.business_outlined, color: colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: colorScheme.surface,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (_createNewClinic && (value == null || value.trim().isEmpty)) {
                          return 'Please enter clinic name';
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    _isLoadingClinics
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            value: _selectedClinicId,
                            decoration: InputDecoration(
                              labelText: 'Select Clinic',
                              prefixIcon: Icon(Icons.business_outlined, color: colorScheme.primary),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: colorScheme.surface,
                            ),
                            items: _clinics.map((clinic) {
                              return DropdownMenuItem<String>(
                                value: clinic['id'] as String,
                                child: Text(clinic['name'] as String),
                              );
                            }).toList(),
                            onChanged: (String? newClinicId) {
                              setState(() => _selectedClinicId = newClinicId);
                            },
                            validator: (value) {
                              if (!_createNewClinic && value == null) {
                                return 'Please select a clinic';
                              }
                              return null;
                            },
                          ),
                  ],
                  const SizedBox(height: 32),
                  
                  // Register Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
                        : Text('Create Account', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: Text('Sign In', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

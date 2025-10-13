import 'package:flutter/material.dart';
import 'package:dental_roots/theme.dart';
import 'package:dental_roots/screens/auth/login_screen.dart';
import 'package:dental_roots/supabase/supabase_config.dart';
import 'package:dental_roots/encounter/config/encounter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  
  // 初始化 Encounter 系统
  await EncounterConfig.initialize();
  
  runApp(const DentalRootsApp());
}

class DentalRootsApp extends StatelessWidget {
  const DentalRootsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental EMR',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}

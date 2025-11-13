import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flmhaiti_fall25team/theme.dart';
import 'package:flmhaiti_fall25team/screens/auth/login_screen.dart';
import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';
import 'package:flmhaiti_fall25team/encounter/config/encounter_config.dart';
import 'package:flmhaiti_fall25team/l10n/arb/l10n.dart';
import 'package:flmhaiti_fall25team/localization/locale_controller.dart';
import 'package:flmhaiti_fall25team/localization/locale_scope.dart';
import 'package:flmhaiti_fall25team/localization/haitian_localization_delegates.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  // 初始化 Encounter 系统
  await EncounterConfig.initialize();

  final localeController = LocaleController();
  await localeController.loadSavedLocale();

  runApp(DentalRootsApp(localeController: localeController));
}

class DentalRootsApp extends StatelessWidget {
  const DentalRootsApp({
    super.key,
    required this.localeController,
  });

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return LocaleScope(
          controller: localeController,
          child: MaterialApp(
            title: 'Dental EMR',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            locale: localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              const HaitianMaterialLocalizationsDelegate(),
              const HaitianCupertinoLocalizationsDelegate(),
              const HaitianWidgetsLocalizationsDelegate(),
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const LoginScreen(),
          ),
        );
      },
    );
  }
}

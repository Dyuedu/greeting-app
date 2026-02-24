import 'package:flutter/material.dart';
import 'package:greeting_app/core/app_providers.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/views/splash_screen/splash_creen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.getProviders(),
      child: MaterialApp(
        title: 'Quản lý lời chúc Tết',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.tetTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

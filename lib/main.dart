import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomquotes/constants/app_settings.dart';
import 'package:randomquotes/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quotes',
      home: const HomeScreen(),
      theme: AppSettings.lightTheme,
      darkTheme: AppSettings.darkTheme,
      themeMode: ThemeMode.system,
      supportedLocales: AppSettings.supportedLocales,
      localizationsDelegates: AppSettings.localizationsDelegates,
      localeResolutionCallback: AppSettings.localeResolutionCallback,
    );
  }
}

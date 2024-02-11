import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomquotes/constants/app_settings.dart';
import 'package:randomquotes/firebase_options.dart';
import 'package:randomquotes/screens/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSettings.loadUserId();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSettings.loadDefaultLanguage(context);
    
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

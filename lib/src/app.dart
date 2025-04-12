import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/main_navigation.dart';

// This class is now just a forwarder to maintain compatibility
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Forward to the MyApp in main.dart
    // The MyApp class now contains the splash screen and theme setup
    return MaterialApp(
      title: 'Ship Monitor',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF333333),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF444444),
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.lightBlue,
          background: Color(0xFF333333),
          surface: Color(0xFF3A3A3A),
        ),
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

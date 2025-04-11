import 'package:flutter/material.dart';
import 'presentation/engine_monitor/engine_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ship Monitor',
      theme: ThemeData.dark(useMaterial3: true),
      home: const EnginePage(),
    );
  }
}

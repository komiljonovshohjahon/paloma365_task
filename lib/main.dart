import 'package:flutter/material.dart';
import 'package:paloma365_task/core/di.dart';
import 'package:paloma365_task/presentation/pages/homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Di().init();

  runApp(const Paloma365App());
}

class Paloma365App extends StatelessWidget {
  const Paloma365App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paloma365',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

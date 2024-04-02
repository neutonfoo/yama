import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yama/views/main/main_screen.dart';

class UIElementsState extends ChangeNotifier {
  bool showUIElements = true;

  void toggle() {
    showUIElements = !showUIElements;
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        home: const MainScreen());
  }
}

void main() => runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => UIElementsState(),
        child: const MainApp(),
      ),
    );

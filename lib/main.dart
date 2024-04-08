import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/home/main_container_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        home: const MainContainerView());
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  await MangaDatabase.loadDatabase();

  return runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => UIElementsState(),
      child: const MainApp(),
    ),
  );
}

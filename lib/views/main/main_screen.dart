import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yama/main.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/manga_details_view.dart';
import 'package:yama/views/main/home_screen.dart';
import 'package:yama/views/partials/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  late Future<List<Manga>> searchResults;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool hide = Provider.of<UIElementsState>(context).showUIElements;

    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          Widget page = const HomePage();

          if (settings.name == MangaChaptersView.routeName) {
            final args = settings.arguments as MangaChaptersViewArguments;
            page = MangaChaptersView(manga: args.manga);
          }

          return MaterialPageRoute(builder: (_) => page);
        },
      ),
      bottomNavigationBar: Visibility(
        visible: hide,
        child: const BottomNav(),
      ),
    );
  }
}

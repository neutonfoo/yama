import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yama/main.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/manga_chapters_view.dart';
import 'package:yama/views/home/home_view.dart';

class MainContainerView extends StatefulWidget {
  const MainContainerView({super.key});

  @override
  State<StatefulWidget> createState() => _MainContainerViewState();
}

class _MainContainerViewState extends State<MainContainerView> {
  late Future<List<Manga>> searchResults;
  int _bottomBarSelectedIndex = 0;

  void _onBottomBarTapped(int index) {
    setState(() {
      _bottomBarSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomBarSelectedIndex == 0
          ? Navigator(
              onGenerateRoute: (settings) {
                Widget page = const HomeView();

                if (settings.name == MangaChaptersView.routeName) {
                  final args = settings.arguments as MangaChaptersViewArguments;
                  page = MangaChaptersView(manga: args.manga);
                }

                return MaterialPageRoute(builder: (_) => page);
              },
            )
          : const Text("Hello"),
//           Navigator(
//               onGenerateRoute: (settings) {
//                 Widget page = const DownloadsView();
//
//                 if (settings.name == MangaChaptersView.routeName) {
//                   final args = settings.arguments as MangaChaptersViewArguments;
//                   page = MangaChaptersView(manga: args.manga);
//                 }
//
//                 return MaterialPageRoute(builder: (_) => page);
//               },
//             ),
      bottomNavigationBar: Visibility(
        visible: Provider.of<UIElementsState>(context).showUIElements,
        child: BottomNavigationBar(
          onTap: (value) => _onBottomBarTapped(value),
          currentIndex: _bottomBarSelectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Downloads',
            )
          ],
        ),
      ),
    );
  }
}

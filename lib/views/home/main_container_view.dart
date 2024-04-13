import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/home/downloads_view.dart';
import 'package:yama/views/home/home_view.dart';

class MainContainerView extends StatefulWidget {
  const MainContainerView({super.key});

  @override
  State<StatefulWidget> createState() => _MainContainerViewState();
}

class _MainContainerViewState extends State<MainContainerView> {
  late Future<List<Manga>> searchResults;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: const [HomeView(), DownloadsView()],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.download),
            icon: Icon(Icons.download_outlined),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }
}

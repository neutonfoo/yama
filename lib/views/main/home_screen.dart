import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/partials/manga_listings_partial.dart';
import 'package:yama/views/partials/manga_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Future<List<Manga>> mangas = MangaGateway.fetchHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'ヤマ',
          style: TextStyle(fontFamily: 'PaletteMosaic'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch<Manga?>(
                context: context,
                delegate: MangaSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MangaListingsPartial(mangas: mangas),
      ),
    );
    // return MangaListings(mangas: mangas);
  }
}

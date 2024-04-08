import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/partials/manga_listings_partial.dart';

class MangaSearchDelegate extends SearchDelegate<Manga?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("Please enter a search term."),
      );
    } else if (query.length < 3) {
      return const Center(
        child: Text("Please enter at least 3 characters."),
      );
    }

    return MangaListingsPartial(
      mangas: MangaGateway.fetchMangas(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}

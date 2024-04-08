import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/partials/manga_listing_partial.dart';

class MangaListingsPartial extends StatelessWidget {
  const MangaListingsPartial({
    super.key,
    required this.mangas,
  });

  final Future<List<Manga>> mangas;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mangas,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No results :("),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => MangaListingPartial(
              manga: snapshot.data![index],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

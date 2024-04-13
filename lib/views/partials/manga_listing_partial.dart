import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/manga_chapters_view.dart';

class MangaListingPartial extends StatelessWidget {
  const MangaListingPartial({
    super.key,
    required this.manga,
    this.inDetailsView = false,
  });

  final Manga manga;
  final bool inDetailsView;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: InkWell(
        onTap: () => {
          if (!inDetailsView)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MangaChaptersView(
                  manga: manga,
                ),
              ),
            )
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: manga.coverUrl,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (manga.rating != null || manga.follows != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (manga.rating != null)
                            Text("Rating ${manga.rating}"),
                          if (manga.rating != null && manga.follows != null)
                            const Text(" • "),
                          if (manga.follows != null)
                            Text("${manga.follows} Follows")
                        ],
                      )
                    ],
                    if (manga.numberOfChapters != null ||
                        manga.status != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (manga.numberOfChapters != null) ...[
                            Text("${manga.numberOfChapters} Chapters"),
                          ],
                          if (manga.numberOfChapters != null &&
                              manga.status != null)
                            const Text(" "),
                          if (manga.status != null) Text("(${manga.status})"),
                        ],
                      ),
                    ],
                    if (manga.yearStarted != null ||
                        manga.lastUpdated != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (manga.yearStarted != null)
                            Text("From ${manga.yearStarted}"),
                          if (manga.yearStarted != null &&
                              manga.lastUpdated != null)
                            const Text(" • "),
                          if (manga.lastUpdated != null)
                            Text("${manga.lastUpdated}")
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

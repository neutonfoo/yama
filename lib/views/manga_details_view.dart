import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/partials/manga_chapter_row_partial.dart';
import 'package:yama/views/partials/manga_listing_partial.dart';

class MangaChaptersViewArguments {
  final Manga manga;
  MangaChaptersViewArguments({required this.manga});
}

class MangaChaptersView extends StatefulWidget {
  const MangaChaptersView({super.key, required this.manga});
  static const routeName = '/details';
  final Manga manga;

  @override
  State<StatefulWidget> createState() {
    return _MangaChaptersViewState();
  }
}

class _MangaChaptersViewState extends State<MangaChaptersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            MangaListingPartial(
              manga: widget.manga,
              inDetailsView: true,
            ),
            FutureBuilder(
              future: widget.manga.getChapters(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => MangaChapterRowPartial(
                        manga: widget.manga,
                        chapter: snapshot.data![index],
                        chapterIndex: index),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}

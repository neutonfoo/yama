import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/manga_chapter_view.dart';

class MangaChapterRowPartial extends StatelessWidget {
  const MangaChapterRowPartial({
    super.key,
    required this.manga,
    required this.chapter,
    required this.chapterIndex,
  });

  final Manga manga;
  final MangaChapter chapter;
  final int chapterIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MangaChapterView(
                  manga: manga,
                  chapterIndex: chapterIndex,
                ),
              ),
            )
          },
          child: Center(
            child: Text("${chapter.name} ${chapter.url}"),
          ),
        ),
      ),
    );
  }
}

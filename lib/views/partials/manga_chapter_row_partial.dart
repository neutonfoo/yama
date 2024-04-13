import 'package:flutter/material.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:yama/views/manga_chapters_view.dart';
import 'package:yama/views/manga_read_view.dart';

class MangaChapterRowPartial extends StatefulWidget {
  const MangaChapterRowPartial({
    super.key,
    required this.editMode,
    required this.manga,
    required this.chapterIndex,
  });

  final MangaChaptersViewStateEditModes editMode;
  final Manga manga;
  final int chapterIndex;

  @override
  State<StatefulWidget> createState() {
    return _MangaChapterRowPartial();
  }
}

class _MangaChapterRowPartial extends State<MangaChapterRowPartial> {
  void readChapter(int chapterIndex, {bool setRead = true}) async {
    // Mark chapter as read
    await MangaDatabase.updateReadChapter(
      widget.manga.id,
      widget.manga.chapters[chapterIndex].id,
      chapterIndex,
      setRead: setRead,
    );

    setState(() {
      widget.manga.chapters[chapterIndex].isRead = setRead;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.manga.chapters[widget.chapterIndex].isRead
          ? Theme.of(context).colorScheme.secondaryContainer
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaReadView(
              manga: widget.manga,
              chapterIndex: widget.chapterIndex,
              readChapterCallback: (int chapterIndex) {
                readChapter(chapterIndex);
              },
            ),
          ),
        );
      },
      leading: widget.editMode == MangaChaptersViewStateEditModes.editMode
          ? Checkbox(
              value: widget.manga.chapters[widget.chapterIndex].isRead,
              onChanged: (bool? value) {
                readChapter(widget.chapterIndex,
                    setRead:
                        !widget.manga.chapters[widget.chapterIndex].isRead);
              },
            )
          : null,
      title: Text(
          "${widget.chapterIndex}. ${widget.manga.chapters[widget.chapterIndex].name}"),
    );
  }
}

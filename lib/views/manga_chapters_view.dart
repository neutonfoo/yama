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

enum MangaChaptersViewStateEditModes {
  viewMode,
  editMode,
  // downloadMode,
}

class _MangaChaptersViewState extends State<MangaChaptersView> {
  MangaChaptersViewStateEditModes currentEditMode =
      MangaChaptersViewStateEditModes.viewMode;

  late final Future<List<MangaChapter>> chapters =
      Future.value(widget.manga.getChapters());

  final ScrollController _controller = ScrollController();
  final double _height = 50.0;

  void _animateDown() {
    if (_controller.position.maxScrollExtent - _controller.offset <
        100 * _height) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _controller.animateTo(
        _controller.offset + 100 * _height,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is used twice
    MangaListingPartial mangaListing = MangaListingPartial(
      manga: widget.manga,
      inDetailsView: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga.name),
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(
                child: const Text("Toggle read"),
                onPressed: () {
                  if (currentEditMode ==
                      MangaChaptersViewStateEditModes.editMode) {
                    setState(() {
                      currentEditMode =
                          MangaChaptersViewStateEditModes.viewMode;
                    });
                  } else {
                    setState(() {
                      currentEditMode =
                          MangaChaptersViewStateEditModes.editMode;
                    });
                  }
                },
              ),
              const MenuItemButton(
                child: Text("Download"),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: chapters,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: ListView(
                  key: const PageStorageKey("MangaListingKey1"),
                  controller: _controller,
                  children: [
                    mangaListing,
                    ListView.separated(
                      key: const PageStorageKey("MangaListingKey2"),
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      controller: _controller,
                      itemBuilder: (context, index) => MangaChapterRowPartial(
                        editMode: currentEditMode,
                        manga: widget.manga,
                        chapterIndex: index,
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 0);
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _animateDown();
                  },
                  child: const Icon(Icons.keyboard_double_arrow_down),
                ),
              );
            }

            return Column(
              children: [
                mangaListing,
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              ],
            );
          },
        ),
      ),
    );
  }
}

//   Column(
//     children: [
//       MangaListingPartial(
//         manga: widget.manga,
//         inDetailsView: true,
//       ),
//       const Expanded(child: Center(child: CircularProgressIndicator()))
//     ],
//   ),
// )
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: [
//             MangaListingPartial(
//               manga: widget.manga,
//               inDetailsView: true,
//             ),
//             const Expanded(child: Center(child: CircularProgressIndicator()))
//             FutureBuilder(
//               future: widget.manga.getChapters(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData &&
//                     snapshot.connectionState == ConnectionState.done) {
//                   return ListView.builder(
//                     physics: const ClampingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) => MangaChapterRowPartial(
//                         manga: widget.manga,
//                         chapter: snapshot.data![index],
//                         chapterIndex: index),
//                   );
//                 }
//
//                 return const Center(child: CircularProgressIndicator());
//               },
//             )
//           ],
//         ),
//       ),
// }
// }

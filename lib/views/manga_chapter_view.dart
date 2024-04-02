import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:yama/main.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:photo_view/photo_view.dart';

class MangaChapterView extends StatefulWidget {
  const MangaChapterView(
      {super.key, required this.manga, required this.chapterIndex});

  final Manga manga;
  final int chapterIndex;

  @override
  State<StatefulWidget> createState() {
    return _MangaChapterView();
  }
}

class _MangaChapterView extends State<MangaChapterView> {
  int _currentPage = 1;
  bool isLoading = true;
  late List<CachedNetworkImageProvider> _images = [];

  @override
  void initState() {
    super.initState();
    fetchChapterPages();
  }

  fetchChapterPages() async {
    final images = await widget.manga.getChapter(widget.chapterIndex);
    final cachedImages =
        images.map((image) => CachedNetworkImageProvider(image));

    setState(() {
      _images = cachedImages.toList();
      isLoading = false;
    });

    // if (mounted) {
    //   for (var image in _images) {
    //     precacheImage(CachedNetworkImageProvider(image), context);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final bool showUIElements =
        Provider.of<UIElementsState>(context).showUIElements;

    return Scaffold(
      appBar: showUIElements
          ? AppBar(
              title: Text("Page $_currentPage of ${_images.length}"),
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                Provider.of<UIElementsState>(context, listen: false).toggle();
              },
              child: PhotoViewGallery.builder(
                gaplessPlayback: true,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index + 1;
                  });
                },
                itemCount: _images.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: _images[index],
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }
}

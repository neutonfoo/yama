import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:yama/main.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:photo_view/photo_view.dart';

class MangaReadView extends StatefulWidget {
  const MangaReadView({
    super.key,
    required this.manga,
    required this.chapterIndex,
    required this.readChapterCallback,
  });

  final Manga manga;
  final int chapterIndex;
  final void Function(int chapterIndex) readChapterCallback;

  @override
  State<StatefulWidget> createState() {
    return _MangaReadViewState();
  }
}

class _MangaReadViewState extends State<MangaReadView> {
  late int _currentChapterIndex;
  int _currentPage = 0;
  bool isLoading = true;
  late List<CachedNetworkImageProvider> _images = [];

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.chapterIndex;
    fetchChapterPages();
  }

  fetchChapterPages() async {
    isLoading = true;
    final images = await widget.manga.getChapter(_currentChapterIndex);
    final cachedImages =
        images.map((image) => CachedNetworkImageProvider(image));

    setState(() {
      _currentPage = 1;
      _images = cachedImages.toList();
      isLoading = false;
    });

    widget.readChapterCallback(_currentChapterIndex);
  }

  @override
  Widget build(BuildContext context) {
    final bool showUIElements =
        Provider.of<UIElementsState>(context).showUIElements;

    return Scaffold(
      appBar: showUIElements
          ? AppBar(
              title: isLoading
                  ? Text(
                      "${widget.manga.name} ${widget.manga.chapters[_currentChapterIndex].name}")
                  : Text(
                      "${widget.manga.chapters[_currentChapterIndex].name}: Page $_currentPage of ${_images.length}"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    setState(() {
                      _currentChapterIndex += 1;
                    });
                    fetchChapterPages();
                  },
                ),
              ],
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PhotoViewGallery.builder(
              allowImplicitScrolling: true,
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
                  onTapUp: (context, details, controllerValue) => {
                    Provider.of<UIElementsState>(context, listen: false)
                        .toggle()
                  },
                );
              },
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      // : GestureDetector(
      //     onTap: () {
      //       Provider.of<UIElementsState>(context, listen: false).toggle();
      //     },
      //     child: PhotoViewGallery.builder(
      //       allowImplicitScrolling: true,
      //       scrollPhysics: const BouncingScrollPhysics(),
      //       onPageChanged: (index) {
      //         setState(() {
      //           _currentPage = index + 1;
      //         });
      //       },
      //       itemCount: _images.length,
      //       builder: (context, index) {
      //         return PhotoViewGalleryPageOptions(
      //           imageProvider: _images[index],
      //           minScale: PhotoViewComputedScale.contained * 0.8,
      //           maxScale: PhotoViewComputedScale.covered * 2,
      //         );
      //       },
      //       loadingBuilder: (context, event) => const Center(
      //         child: CircularProgressIndicator(),
      //       ),
      //     ),
      //   ),
    );
  }
}

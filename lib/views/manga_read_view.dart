import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:yama/main.dart';
import 'package:yama/utils/manga_gateway.dart';
import 'package:photo_view/photo_view.dart';

class MangaReadView extends StatefulWidget {
  const MangaReadView(
      {super.key, required this.manga, required this.chapterIndex});

  final Manga manga;
  final int chapterIndex;

  @override
  State<StatefulWidget> createState() {
    return _MangaReadViewState();
  }
}

class _MangaReadViewState extends State<MangaReadView> {
  int _currentPage = 0;
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
      _currentPage = 1;
      _images = cachedImages.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showUIElements =
        Provider.of<UIElementsState>(context).showUIElements;

    return Scaffold(
      appBar: showUIElements
          ? AppBar(
              title: _currentPage == 0
                  ? const Text("Loading")
                  : Text("Page $_currentPage of ${_images.length}"),
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
                  minScale: PhotoViewComputedScale.contained * 0.5,
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

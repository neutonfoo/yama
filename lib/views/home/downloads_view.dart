import 'package:flutter/material.dart';

class DownloadsView extends StatefulWidget {
  const DownloadsView({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadsViewState();
}

class _DownloadsViewState extends State<DownloadsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Downloads',
          style: TextStyle(fontFamily: 'PaletteMosaic'),
        ),
      ),
      body: const Padding(padding: EdgeInsets.all(8.0), child: Text("Hello")),
    );
    // return MangaListings(mangas: mangas);
  }
}

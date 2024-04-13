// https://docs.flutter.dev/cookbook/networking/fetch-data
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Manga {
  final String name;
  final String id;
  final String coverUrl;
  final String? status;
  final int? yearStarted;
  final num? numberOfChapters;
  final String? lastUpdated;
  final String? follows;
  final num? rating;

  List<MangaChapter> chapters = [];

  Manga({
    required this.name,
    required this.id,
    required this.coverUrl,
    required this.status,
    required this.yearStarted,
    required this.numberOfChapters,
    required this.lastUpdated,
    required this.follows,
    required this.rating,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'id': String id,
        'coverUrl': String coverUrl,
        'status': String? status,
        'yearStarted': int? yearStarted,
        'numberOfChapters': num? numberOfChapters,
        'lastUpdated': String? lastUpdated,
        'follows': String? follows,
        'rating': num? rating,
      } =>
        Manga(
          name: name,
          id: id,
          coverUrl: coverUrl,
          status: status,
          yearStarted: yearStarted,
          numberOfChapters: numberOfChapters,
          lastUpdated: lastUpdated,
          follows: follows,
          rating: rating,
        ),
      _ => throw const FormatException('Failed to load manga.'),
    };
  }

  Future<List<MangaChapter>> getChapters() async {
    if (chapters.isNotEmpty) {
      return chapters;
    }
    
    // If not cached, get initial list and set .isRead
    chapters = await MangaGateway.fetchChapters(this);

    final readChapters = await MangaDatabase.getReadChapters(id);

    for (var readChapter in readChapters) {
      chapters[readChapter].isRead = true;
    }

    return chapters;
  }

  Future<List<String>> getChapter(int chapterIndex) async {
    if (chapters[chapterIndex].pages.isNotEmpty) {
      return chapters[chapterIndex].pages;
    }

    chapters[chapterIndex].pages =
        await MangaGateway.fetchChapter(this, chapters[chapterIndex]);

    return chapters[chapterIndex].pages;
  }
}

class MangaChapter {
  final String name;
  final String id;
  final int index;

  List<String> pages = [];
  bool isRead = false;

  MangaChapter({required this.name, required this.id, required this.index});

  factory MangaChapter.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'id': String id,
        'index': int index,
      } =>
        MangaChapter(name: name, id: id, index: index),
      _ => throw const FormatException('Failed to load manga chapters.'),
    };
  }
}

class MangaGateway {
  static String baseUrl = dotenv.env['API_URL'] ?? "";

  static Future<List<Manga>> fetchHome() async {
    final response = await http.post(
      Uri.parse('$baseUrl/home'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable mangasRaw = jsonDecode(response.body);
      return List<Manga>.from(mangasRaw.map((m) => Manga.fromJson(m)));
    } else {
      throw Exception('Failed to load search results');
    }
  }

  static Future<List<Manga>> fetchMangas(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/search'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      Iterable mangasRaw = jsonDecode(response.body);
      return List<Manga>.from(mangasRaw.map((m) => Manga.fromJson(m)));
    } else {
      throw Exception('Failed to load search results');
    }
  }

  static Future<List<MangaChapter>> fetchChapters(Manga manga) async {
    final response = await http.post(Uri.parse('$baseUrl/chapters'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"mangaId": manga.id}));

    if (response.statusCode == 200) {
      Iterable mangaChaptersRaw = jsonDecode(response.body);
      return List<MangaChapter>.from(
          mangaChaptersRaw.map((c) => MangaChapter.fromJson(c)));
    } else {
      throw Exception('Failed to load search results');
    }
  }

  static Future<List<String>> fetchChapter(
      Manga manga, MangaChapter chapter) async {
    final response = await http.post(Uri.parse('$baseUrl/chapter'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"mangaId": manga.id, "chapterId": chapter.id}));

    if (response.statusCode == 200) {
      Iterable mangaChapterPagesRaw = jsonDecode(response.body);
      return List<String>.from(mangaChapterPagesRaw);
    } else {
      throw Exception('Failed to load search results');
    }
  }
}

class MangaDatabase {
  static late final Database database;

  static loadDatabase() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'manga_database.db'));

    database = await openDatabase(
      join(await getDatabasesPath(), 'manga_database.db'),
      version: 1,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          'CREATE TABLE chapters (manga_id TEXT, chapter_id TEXT, chapter_index INTEGER, is_read INTEGER, is_downloaded INTEGER, PRIMARY KEY (manga_id, chapter_id))',
        );

        db.execute(
            'CREATE TABLE manga (id TEXT PRIMARY KEY, name TEXT, rating TEXT, follows TEXT, chapters TEXT, status TEXT, last_uploaded TEXT)');
      },
    );
  }

  static getReadChapters(String mangaId) async {
    final mangaReadChapters = await database.query('chapters',
        columns: ["chapter_index"],
        where: 'manga_id = ? AND is_read = 1',
        whereArgs: [mangaId]);

    if (mangaReadChapters.isEmpty) {
      return [];
    }

    return mangaReadChapters
        .map(
          (e) => e["chapter_index"],
        )
        .toList();
  }

  static updateReadChapter(
    String mangaId,
    String chapterId,
    int chapterIndex, {
    bool setRead = true,
  }) async {
    await database.insert(
        'chapters',
        {
          "manga_id": mangaId,
          "chapter_id": chapterId,
          "chapter_index": chapterIndex,
          "is_read": setRead ? 1 : 0,
          "is_downloaded": 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

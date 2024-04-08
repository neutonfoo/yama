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
    chapters = await MangaGateway.fetchChapters(this);
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
  List<String> pages = [];

  MangaChapter({required this.name, required this.id});

  factory MangaChapter.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'id': String id,
      } =>
        MangaChapter(
          name: name,
          id: id,
        ),
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
    database = await openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
    );
  }
}

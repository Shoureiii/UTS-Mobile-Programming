import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/game.dart';

class GameApi {
  Future<List<Game>> fetchGames() async {
    final response = await http.get(
      Uri.parse('https://www.freetogame.com/api/games'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data game. Status: ${response.statusCode}',
      );
    }

    final decodedData = json.decode(response.body);

    if (decodedData is! List) {
      throw Exception('Format data game dari API tidak sesuai.');
    }

    return decodedData
        .map((item) => Game.fromJson(Map<String, dynamic>.from(item)))
        .where((game) => game.title.isNotEmpty && game.thumbnail.isNotEmpty)
        .toList();
  }

  Future<String?> fetchGameScreenshot(int gameId) async {
    final response = await http.get(
      Uri.parse('https://www.freetogame.com/api/game?id=$gameId'),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final decodedData = json.decode(response.body);

    if (decodedData is! Map<String, dynamic>) {
      return null;
    }

    final screenshots = decodedData['screenshots'];

    if (screenshots is! List || screenshots.isEmpty) {
      return null;
    }

    final firstScreenshot = screenshots.first;

    if (firstScreenshot is Map<String, dynamic>) {
      return firstScreenshot['image']?.toString();
    }

    return null;
  }
}

class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? 'Tanpa judul',
      thumbnail: json['thumbnail']?.toString() ?? '',
      genre: json['genre']?.toString() ?? 'Tidak diketahui',
      platform: json['platform']?.toString() ?? 'Tidak diketahui',
    );
  }
}
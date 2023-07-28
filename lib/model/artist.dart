class Artist {
  final String id;
  final String name;
  final String type;
  final List<Map<String, dynamic>> images;
  final List<String> genres;

  Artist(this.id, this.name, this.type, this.images, this.genres);

  factory Artist.fromMap(Map<String, dynamic> respData) {
    return Artist(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      respData['images'] ?? [],
      respData['genres'] ?? []
    );
  }
}

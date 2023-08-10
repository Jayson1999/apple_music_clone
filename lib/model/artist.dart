import 'package:apple_music_clone/model/image_info.dart';

class Artist {
  final String id;
  final String name;
  final String type;
  final List<ImageInfo> images;
  final List<String> genres;

  Artist({required this.id, required this.name, required this.type, required this.images, required this.genres});

  factory Artist.fromMap(Map<String, dynamic> respData) {
    return Artist(
      id: respData['id'],
      name: respData['name'],
      type: respData['type'],
      images: [for (Map<String, dynamic> imgMap in respData['images'] ?? []) ImageInfo.fromMap(imgMap)],
      genres: [for (String genre in respData['genres'] ?? []) genre],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'images': images.map((image) => image.toJson()).toList(),
      'genres': genres,
    };
  }
}

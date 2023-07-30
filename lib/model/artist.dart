import 'package:apple_music_clone/model/image_info.dart';

class Artist {
  final String id;
  final String name;
  final String type;
  final List<ImageInfo> images;
  final List<String> genres;

  Artist(this.id, this.name, this.type, this.images, this.genres);

  factory Artist.fromMap(Map<String, dynamic> respData) {
    List<ImageInfo> images = (respData['images'] as List?)?.map<ImageInfo>((imageMap) => ImageInfo.fromMap(imageMap)).toList() ?? [];
    List<String> genres = (respData['genres'] as List?)?.cast<String>() ?? [];

    return Artist(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      images,
      genres
    );
  }
}

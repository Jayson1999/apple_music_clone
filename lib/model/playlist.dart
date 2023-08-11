import 'package:apple_music_clone/model/image_info.dart';
import 'package:apple_music_clone/model/track.dart';


class Playlist {
  final String id;
  final String name;
  final String type;
  final String description;
  final List<ImageInfo> images;
  final List<Track> tracks;

  Playlist(
      {required this.id,
        required this.name,
        required this.type,
        required this.description,
        required this.images,
        required this.tracks});

  factory Playlist.fromMap(Map<String, dynamic> respData) {
    return Playlist(
      id: respData['id'],
      name: respData['name'],
      type: respData['type'],
      description: respData['description'],
      images: [for (Map<String, dynamic> imgMap in respData['images']) ImageInfo.fromMap(imgMap)],
      tracks: [for (Map<String, dynamic> trackMap in respData['tracks'] ?? []) Track.fromMap(trackMap)],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'images': images.map((image) => image.toJson()).toList(),
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}
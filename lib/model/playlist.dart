import 'package:apple_music_clone/model/image_info.dart';
import 'package:apple_music_clone/model/track.dart';


class Playlist {
  final String id;
  final String name;
  final String type;
  final String description;
  final List<ImageInfo> images;
  final List<Track> tracks;

  Playlist(this.id, this.name, this.type, this.description, this.images, this.tracks);

  factory Playlist.fromMap(Map<String, dynamic> respData) {
    List<ImageInfo> images = (respData['images'] as List?)?.map<ImageInfo>((imageMap) => ImageInfo.fromMap(imageMap)).toList() ?? [];
    List<Track> tracks = (respData['tracks']?['items'] as List?)?.map<Track>((trackMap) => Track.fromMap(trackMap)).toList() ?? [];

    return Playlist(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      respData['description'] ?? '',
      images,
      tracks,
    );
  }
}
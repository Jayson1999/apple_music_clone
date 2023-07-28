import 'package:apple_music_clone/model/track.dart';


class Playlist {
  final String id;
  final String name;
  final String type;
  final String description;
  final List<Map<String, dynamic>> images;
  final List<Track> tracks;

  Playlist(this.id, this.name, this.type, this.description, this.images, this.tracks);

  factory Playlist.fromMap(Map<String, dynamic> respData) {
    return Playlist(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      respData['description'] ?? '',
      respData['images'] ?? [],
      respData['tracks']['items'].map((trackMap) => Track.fromMap(trackMap)).toList(),
    );
  }
}
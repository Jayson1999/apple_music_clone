import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';


class Track {
  final String id;
  final String name;
  final String type;
  final int durationInMs;
  final int popularity;
  final int trackNumber;
  final Album album;
  final List<Artist> artists;

  Track(this.id, this.name, this.type, this.durationInMs, this.popularity, this.trackNumber, this.album, this.artists);

  factory Track.fromMap(Map<String, dynamic> respData) {
    return Track(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      respData['duration_ms'] ?? 0,
      respData['popularity'] ?? 0,
      respData['track_number'] ?? 0,
      respData['album'].map((albumMap) => Album.fromMap(albumMap)),
      respData['artists'].map((artistMap) => Artist.fromMap(artistMap)).toList()
    );
  }
}
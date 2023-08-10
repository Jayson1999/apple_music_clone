import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';


class Track {
  final String id;
  final String name;
  final String type;
  final int durationInMs;
  final int? popularity;
  final int trackNumber;
  final Album? album;
  final List<Artist> artists;

  Track(
      {required this.id,
        required this.name,
        required this.type,
        required this.durationInMs,
        this.popularity,
        required this.trackNumber,
        this.album,
        required this.artists});

  factory Track.fromMap(Map<String, dynamic> respData) {
    return Track(
      id: respData['id'],
      name: respData['name'],
      type: respData['type'],
      durationInMs: respData['duration_ms'],
      popularity: respData['popularity'],
      trackNumber: respData['track_number'],
      album: respData['album']!=null? Album.fromMap(respData['album']): null,
      artists: [for (Map<String, dynamic> artistMap in respData['artists'] ?? []) Artist.fromMap(artistMap)],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'duration_ms': durationInMs,
      'popularity': popularity,
      'track_number': trackNumber,
      'album': album?.toJson(),
      'artists': artists.map((artist) => artist.toJson()).toList(),
    };
  }
}
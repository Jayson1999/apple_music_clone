import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/track.dart';


class Album {
  final String id;
  final String name;
  final String type;
  final List<Track> tracks;
  final List<Artist> artists;
  final int totalTracks;
  final String releaseDate;
  final List<String> genre;
  final String label;
  final List<Map<String, dynamic>> images;
  final List<Map<String, dynamic>> copyrights;

  Album(this.id, this.name, this.type, this.tracks, this.artists, this.totalTracks, this.releaseDate, this.genre, this.label, this.images, this.copyrights);

  factory Album.fromMap(Map<String, dynamic> respData) {
    return Album(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      respData['tracks']['items'].map((trackMap) => Track.fromMap(trackMap)).toList(),
      respData['artists'].map((artistMap) => Artist.fromMap(artistMap)).toList(),
      respData['total_tracks'] ?? 0,
      respData['release_date'] ?? '',
      respData['genres'] ?? [],
      respData['label'] ?? '',
      respData['images'] ?? [],
      respData['copyrights'] ?? [],
    );
  }

}

import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/copyright_info.dart';
import 'package:apple_music_clone/model/image_info.dart';
import 'package:apple_music_clone/model/track.dart';


class Album {
  final String id;
  final String name;
  final String type;
  final List<Track> tracks;
  final List<Artist> artists;
  final int totalTracks;
  final String releaseDate;
  final List<String> genres;
  final String label;
  final List<ImageInfo> images;
  final List<CopyrightInfo> copyrights;

  Album(
      {required this.id,
        required this.name,
        required this.type,
        required this.tracks,
        required this.artists,
        required this.totalTracks,
        required this.releaseDate,
        required this.genres,
        required this.label,
        required this.images,
        required this.copyrights});

  factory Album.fromMap(Map<String, dynamic> respData) {
    return Album(
      id: respData['id'],
      name: respData['name'],
      type: respData['type'],
      tracks: [for (Map<String, dynamic> trackMap in respData['tracks'] ?? []) Track.fromMap(trackMap)],
      artists: [for (Map<String, dynamic> artistMap in respData['artists'] ?? []) Artist.fromMap(artistMap)],
      totalTracks: respData['total_tracks'],
      releaseDate: respData['release_date'],
      genres: [for (String genre in respData['genres'] ?? []) genre],
      label: respData['label'] ?? '',
      images: [for (Map<String, dynamic> imgMap in respData['images']) ImageInfo.fromMap(imgMap)],
      copyrights: [for (Map<String, dynamic> copyrightMap in respData['copyrights'] ?? []) CopyrightInfo.fromMap(copyrightMap)],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'tracks': tracks.map((track) => track.toJson()).toList(),
      'artists': artists.map((artist) => artist.toJson()).toList(),
      'total_tracks': totalTracks,
      'release_date': releaseDate,
      'genres': genres,
      'label': label,
      'images': images.map((image) => image.toJson()).toList(),
      'copyrights': copyrights.map((copyright) => copyright.toJson()).toList(),
    };
  }

}

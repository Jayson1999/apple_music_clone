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
  final List<String> genre;
  final String label;
  final List<ImageInfo> images;
  final List<CopyrightInfo> copyrights;

  Album(this.id, this.name, this.type, this.tracks, this.artists, this.totalTracks, this.releaseDate, this.genre, this.label, this.images, this.copyrights);

  factory Album.fromMap(Map<String, dynamic> respData) {
    List<Track> tracks = (respData['tracks']?['items'] as List?)?.map<Track>((trackMap) => Track.fromMap(trackMap)).toList() ?? [];
    List<Artist> artists = (respData['artists'] as List?)?.map((artistMap) => Artist.fromMap(artistMap)).toList() ?? [];
    List<ImageInfo> images = (respData['images'] as List?)?.map<ImageInfo>((imageMap) => ImageInfo.fromMap(imageMap)).toList() ?? [];
    List<CopyrightInfo> copyrights = (respData['copyrights'] as List?)?.map<CopyrightInfo>((copyrightMap) => CopyrightInfo.fromMap(copyrightMap)).toList() ?? [];
    List<String> genres = (respData['genres'] as List?)?.cast<String>() ?? [];

    return Album(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      tracks,
      artists,
      respData['total_tracks'] ?? 0,
      respData['release_date'] ?? '',
      genres,
      respData['label'] ?? '',
      images,
      copyrights,
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
      'genres': genre,
      'label': label,
      'images': images.map((image) => image.toJson()).toList(),
      'copyrights': copyrights.map((copyright) => copyright.toJson()).toList(),
    };
  }

}

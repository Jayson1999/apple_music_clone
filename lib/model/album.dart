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

    return Album(
      respData['id'] ?? '',
      respData['name'] ?? '',
      respData['type'] ?? '',
      tracks,
      artists,
      respData['total_tracks'] ?? 0,
      respData['release_date'] ?? '',
      respData['genres'] ?? [],
      respData['label'] ?? '',
      images,
      copyrights,
    );
  }

}

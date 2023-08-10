import 'dart:developer';
import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class ArtistService {
  final APIHelper _apiHelper;

  ArtistService(this._apiHelper);

  Future<List<Artist>> getArtistsByIds(List<String> ids) async {
    Map<String, dynamic>? queryParams = {'ids': ids.join(',')};

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.artistsSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List artistMaps = response.data['artists'] ?? [];
      List<Artist> artists = [for(Map<String, dynamic> artistMap in artistMaps) Artist.fromMap(artistMap)];

      return artists;
    }
    catch (error) {
      final String errorMsg = 'GetArtistsByIds failed: $error';
      log(errorMsg, error: 'ERROR', name: 'GetArtistsByIds');
      throw Exception(errorMsg);
    }
  }

  Future<List<Track>> getArtistTopTracks(String artistId, {String region = 'US'}) async {
    Map<String, dynamic>? queryParams = {'market': region};

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(
          '${_apiHelper.artistsSubUrl}/$artistId/top-tracks',
          queryParameters: queryParams
      );

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List trackMaps = response.data['tracks'] ?? [];
      List<Track> tracks = [for(Map<String, dynamic> trackMap in trackMaps) Track.fromMap(trackMap)];

      return tracks;
    }
    catch (error, stack) {
      final String errorMsg = 'GetArtistTopTracks failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetArtistTopTracks');
      throw Exception(errorMsg);
    }
  }

  Future<List<Artist>> getRelatedArtists(String artistId) async {
    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get('${_apiHelper.artistsSubUrl}/$artistId/related-artists');

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List artistMaps = response.data['artists'] ?? [];
      List<Artist> artists = [for(Map<String, dynamic> artistMap in artistMaps) Artist.fromMap(artistMap)];

      return artists;
    }
    catch (error, stack) {
      final String errorMsg = 'GetRelatedArtists failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetRelatedArtists');
      throw Exception(errorMsg);
    }
  }

  Future<List<Album>> getArtistAlbums(String artistId) async {
    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get('${_apiHelper.artistsSubUrl}/$artistId/albums');

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List albumMaps = response.data['items'] ?? [];
      List<Album> albums = [for (Map<String, dynamic> albumMap in albumMaps) Album.fromMap(albumMap)];

      return albums;
    }
    catch (error, stack) {
      final String errorMsg = 'GetArtistAlbums failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetArtistAlbums');
      throw Exception(errorMsg);
    }
  }

  Future<List<Artist>> getArtistsFromAlbums(List<Album> albums) async {
    try {
      final List<String> artistsIds = [for (Album album in albums) for (Artist artist in album.artists) artist.id];
      final List<Artist> artists = await getArtistsByIds(artistsIds);

      return artists;

    } catch (error, stack) {
      final String errorMsg = 'GetArtistsFromAlbums failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetArtistsFromAlbums');
      throw Exception(errorMsg);
    }
  }

}

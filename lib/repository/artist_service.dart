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

      List<Artist> artistsFromResp = (response.data['artists'] as List?)?.map((artistMap) => Artist.fromMap(artistMap)).toList() ?? [];
      return artistsFromResp;
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

      List<Track> tracksFromResp = (response.data['tracks'] as List?)?.map((trackMap) => Track.fromMap(trackMap)).toList() ?? [];
      return tracksFromResp;
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

      List<Artist> artistsFromResp = (response.data['artists'] as List?)?.map((artistMap) => Artist.fromMap(artistMap)).toList() ?? [];
      return artistsFromResp;
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

      List<Album> albumsFromResp = (response.data['items'] as List?)?.map((albumMap) => Album.fromMap(albumMap)).toList() ?? [];
      return albumsFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetArtistAlbums failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetArtistAlbums');
      throw Exception(errorMsg);
    }
  }

}

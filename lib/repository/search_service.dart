import 'dart:developer';
import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class SearchService {
  final APIHelper _apiHelper;
  final List<String> allowedSearchTypes = ['album', 'artist', 'playlist', 'track'];

  SearchService(this._apiHelper);

  Future<List> getSearchResults(String queryStr, {String country = '', int limit = 5}) async {
    Map<String, dynamic> queryParams = {
      'q': queryStr,
      'type': allowedSearchTypes.join(','),
      'limit': limit,
    };
    if (country.isNotEmpty){
      queryParams['market'] = country;
    }

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.searchSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List albumResponse = response.data['albums']?['items'] ?? [];
      List artistResponse = response.data['artists']?['items'] ?? [];
      List playlistResponse = response.data['playlists']?['items'] ?? [];
      List trackResponse = response.data['tracks']?['items'] ?? [];

      List<Album> albums = [for (Map<String, dynamic> albumData in albumResponse) Album.fromMap(albumData)];
      List<Artist> artists = [for (Map<String, dynamic> artistData in artistResponse) Artist.fromMap(artistData)];
      List<Track> tracks = [for (Map<String, dynamic> trackData in trackResponse) Track.fromMap(trackData)];
      List<Playlist> playlists = [];
      for (Map<String, dynamic>? playlistMap in playlistResponse){
        // Some responses are null
        if (playlistMap==null){
          continue;
        }
        // Remove inconsistent data & data type
        playlistMap.remove('tracks');
        playlists.add(Playlist.fromMap(playlistMap));
      }

      return [...albums, ...artists, ...playlists, ...tracks];
    }
    catch (error, stack) {
      final String errorMsg = 'GetSearchResults failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetSearchResults');
      throw Exception(errorMsg);
    }
  }

}

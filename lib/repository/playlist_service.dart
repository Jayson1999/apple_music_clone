import 'dart:developer';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class PlaylistService {
  final APIHelper _apiHelper;

  PlaylistService(this._apiHelper);

  Future<Playlist> getPlaylistById(String playlistId) async {
    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get('${_apiHelper.playlistsSubUrl}/$playlistId');

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      Playlist playlistFromResp = Playlist.fromMap(response.data);
      return playlistFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetPlaylistById failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetPlaylistById');
      throw Exception(errorMsg);
    }
  }

  Future<List<Playlist>> getCategoryPlaylists(String categoryId) async {
    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get('${_apiHelper.categoriesSubUrl}/$categoryId/playlists');

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Playlist> playlistsFromResp = (response.data['playlists']?['items'] as List?)?.map((playlistMap) => Playlist.fromMap(playlistMap)).toList() ?? [];
      return playlistsFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetCategoryPlaylists failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetCategoryPlaylists');
      throw Exception(errorMsg);
    }
  }

  Future<Map<String, List<Playlist>>> getFeaturedPlaylistsWithMsg({String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty ? {'country': country} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.featuredPlaylistsSubUrl,  queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Playlist> playlistsFromResp = (response.data['playlists']?['items'] as List?)?.map((playlistMap) => Playlist.fromMap(playlistMap)).toList() ?? [];
      return {
        response.data['message']?? '': playlistsFromResp
      };
    }
    catch (error, stack) {
      final String errorMsg = 'GetFeaturedPlaylistsWithMsg failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetFeaturedPlaylistsWithMsg');
      throw Exception(errorMsg);
    }
  }

}

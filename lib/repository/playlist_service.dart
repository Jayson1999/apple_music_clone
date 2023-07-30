import 'dart:developer';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class PlaylistService {
  final APIHelper _apiHelper;

  PlaylistService(this._apiHelper);

  Future<Playlist> getPlaylistById(String playlistId, {String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty ? {'country': country} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(
          '${_apiHelper.playlistsSubUrl}/$playlistId',
          queryParameters: queryParams
      );

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      Playlist playlistFromResp = Playlist.fromMap(response.data);
      return playlistFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetPlaylistById failed for playlist $playlistId: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetPlaylistById');
      throw Exception(errorMsg);
    }
  }

  Future<List<Playlist>> getCategoryPlaylists(String categoryId, {String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty ? {'country': country} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(
          '${_apiHelper.categoriesSubUrl}/$categoryId/playlists',
          queryParameters: queryParams
      );

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<dynamic>? playlistData = response.data['playlists']?['items'] as List<dynamic>?;
      List<Playlist> playlistsFromResp = (playlistData ?? []).whereType<Map<String, dynamic>>().map((playlistMap) => Playlist.fromMap(playlistMap)).toList();

      return playlistsFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetCategoryPlaylists failed for category $categoryId: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetCategoryPlaylists');
      throw Exception(errorMsg);
    }
  }

  Future<List<Playlist>> getFeaturedPlaylists({String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty ? {'country': country} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.featuredPlaylistsSubUrl,  queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Playlist> playlistsFromResp = (response.data['playlists']?['items'] as List?)?.map((playlistMap) => Playlist.fromMap(playlistMap)).toList() ?? [];
      return playlistsFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetFeaturedPlaylists failed for country $country: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetFeaturedPlaylists');
      throw Exception(errorMsg);
    }
  }

  Future<List<List<Playlist>>> getPlaylistsFromCategories(List<Category> categories, {String country = ''}) async {
    try {
      final List<String> categoriesIds = [for (Category category in categories) category.id];
      final List<Future<List<Playlist>>> playlistsFuture = [for (String id in categoriesIds) getCategoryPlaylists(id, country: country)];
      final List<List<Playlist>> playlists = await Future.wait(playlistsFuture);

      return playlists;

    } catch (error, stack) {
      final String errorMsg = 'GetPlaylistsFromCategories failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetPlaylistsFromCategories');
      throw Exception(errorMsg);
    }
  }

}

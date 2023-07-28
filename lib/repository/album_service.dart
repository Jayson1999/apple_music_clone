import 'dart:developer';
import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class AlbumService {
  final APIHelper _apiHelper;
  final String _browseSubUrl = '/browse/new-releases';
  final String _albumSubUrl = '/albums';

  AlbumService(this._apiHelper);

  Future<List<Album>> getNewReleasesAlbum({String region = ''}) async {
    Map<String, dynamic>? queryParams = region.isNotEmpty ? {'country': region} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_browseSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Album> albumsFromResp = (response.data['albums']?['items'] as List?)?.map((albumMap) => Album.fromMap(albumMap)).toList() ?? [];
      return albumsFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetNewReleasesAlbum failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetNewReleasesAlbum');
      throw Exception(errorMsg);
    }
  }

  Future<List<Album>> getAlbumsByIds(List<String> ids) async {
    Map<String, dynamic>? queryParams = {'ids': ids.join(',')};

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_albumSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Album> albumsFromResp = (response.data['albums']?['items'] as List?)?.map((albumMap) => Album.fromMap(albumMap)).toList() ?? [];
      return albumsFromResp;
    }
    catch (error) {
      final String errorMsg = 'GetAlbumsByIds failed: $error';
      log(errorMsg, error: 'ERROR', name: 'GetAlbumsByIds');
      throw Exception(errorMsg);
    }
  }

}

import 'dart:developer';
import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class AlbumService {
  final APIHelper _apiHelper;

  AlbumService(this._apiHelper);

  Future<List<Album>> getNewReleasesAlbum({String region = ''}) async {
    Map<String, dynamic>? queryParams = region.isNotEmpty ? {'country': region} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.newReleaseSubUrl, queryParameters: queryParams);
      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List albumMaps = response.data['albums']?['items'] ?? [];
      List<Album> albums = [];
      Map<String, dynamic> idTracksMap = {};

      for (Map<String, dynamic> albumMap in albumMaps){
        Album album = Album.fromMap(albumMap);
        idTracksMap.addAll({album.id: null});
        albums.add(album);
      }

      // Get tracks that are not in current API response
      for (Album album in await getAlbumsByIds(idTracksMap.keys.toList(), country: region)){
        idTracksMap[album.id] = album.tracks;
      }
      for (Album album in albums){
        for (Track track in idTracksMap[album.id] ?? []){
          album.tracks.add(track);
        }
      }

      return albums;
    }
    catch (error, stack) {
      final String errorMsg = 'GetNewReleasesAlbum failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetNewReleasesAlbum');
      throw Exception(errorMsg);
    }
  }

  Future<List<Album>> getAlbumsByIds(List<String> ids, {String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty
        ? {'ids': ids.join(','), 'market': country}
        : {'ids': ids};

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.albumSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List albumMaps = response.data['albums'] ?? [];
      List<Album> albums = [];
      for (Map<String, dynamic> albumMap in albumMaps){
        albumMap.addAll({
          'tracks': albumMap['tracks']['items']
        });
        albums.add(Album.fromMap(albumMap));
      }

      return albums;
    }
    catch (error, stack) {
      final String errorMsg = 'GetAlbumsByIds failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetAlbumsByIds');
      throw Exception(errorMsg);
    }
  }

}

import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class AlbumService {
  final APIHelper _apiHelper;
  final String _subUrl;

  AlbumService(this._apiHelper, String storeFront, String albumId)
      : _subUrl = '/catalog/$storeFront/albums/$albumId';

  Future<List<Album>> getAlbumsWithId() async {
    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_subUrl);
      if (response.statusCode != 200){
        throw Exception('GetAlbumsWithId failed: $response');
      }

      List<Album> albumsFromResp = response.data['data'].map((data) => Album.fromMap(data)).toList();
      return albumsFromResp;
    }
    catch (e) {
      throw Exception('GetAlbumsWithId failed: $e');
    }
  }
}

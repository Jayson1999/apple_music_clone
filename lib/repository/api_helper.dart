import 'package:apple_music_clone/repository/auth_helper.dart';
import 'package:dio/dio.dart';


class APIHelper {
  final String _baseUrl = 'https://api.spotify.com/v1';
  late Dio _dio;
  late Map<String, dynamic> _header;

  APIHelper(){
    _header = {
      'Authorization': 'Bearer '
    };
    _dio = Dio(BaseOptions(baseUrl: _baseUrl, headers: _header));
  }

  Dio get dio => _dio;

  Future<void> updateAuthorizationHeader() async {
    String? accessToken = await AuthHelper().getAccessToken();
    _header['Authorization'] = 'Bearer $accessToken';
    _dio.options.headers = _header;
  }

}

import 'package:dio/dio.dart';


class APIHelper {
  final String _baseUrl = 'https://api.music.apple.com/v1';
  final String _authToken = 'AUTHORIZATION TOKEN HERE';
  late Dio _dio;
  late Map<String, dynamic> _header;

  APIHelper(){
    _header = {
      'Authorization': 'Bearer $_authToken',
    };
    _dio = Dio(BaseOptions(baseUrl: _baseUrl, headers: _header));
  }

  Dio get dio => _dio;

}

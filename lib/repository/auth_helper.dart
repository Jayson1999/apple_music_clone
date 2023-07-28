import 'package:apple_music_clone/utils/config.dart';
import 'dart:developer';
import 'package:dio/dio.dart';


class AuthHelper {
  static const String _tokenUrl = 'https://accounts.spotify.com/api/token';
  static const String _clientId = clientId;
  static const String _clientSecret = clientSecret;

  final Dio _dio = Dio();
  String? _accessToken;
  DateTime? _expirationDate;

  Future<String?> getAccessToken() async {
    if (_accessToken != null && _expirationDate != null) {
      if (_expirationDate!.isAfter(DateTime.now())) {
        return _accessToken;
      }
    }

    _dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    try {
      final response = await _dio.post(
        _tokenUrl,
        data: {
          'grant_type': 'client_credentials',
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response);
      }

      _accessToken = response.data['access_token'];
      _expirationDate = DateTime.now().add(Duration(seconds: response.data['expires_in']));

      return _accessToken;
    }
    catch (error) {
      final String errorMsg = 'getAccessToken failed: $error';
      log(errorMsg, error: 'ERROR', name: 'getAccessToken');
      return null;
    }
  }

}

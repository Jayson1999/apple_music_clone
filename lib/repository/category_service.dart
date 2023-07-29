import 'dart:developer';
import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/repository/api_helper.dart';


class CategoryService {
  final APIHelper _apiHelper;

  CategoryService(this._apiHelper);

  Future<List<Category>> getBrowseCategories({String country = ''}) async {
    Map<String, dynamic>? queryParams = country.isNotEmpty ? {'country': country} : null;

    try {
      await _apiHelper.updateAuthorizationHeader();
      final response = await _apiHelper.dio.get(_apiHelper.categoriesSubUrl, queryParameters: queryParams);

      if (response.statusCode != 200){
        throw Exception('$response');
      }

      List<Category> categoriesFromResp = (response.data['categories']?['items'] as List?)?.map((categoryMap) => Category.fromMap(categoryMap)).toList() ?? [];
      return categoriesFromResp;
    }
    catch (error, stack) {
      final String errorMsg = 'GetBrowseCategories failed: $error\n$stack';
      log(errorMsg, error: 'ERROR', name: 'GetBrowseCategories');
      throw Exception(errorMsg);
    }
  }

}

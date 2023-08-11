import 'package:apple_music_clone/model/category_icon_info.dart';


class Category {
  final String id;
  final String name;
  final List<CategoryIconInfo> categoryIconsInfo;

  Category({required this.id, required this.name, required this.categoryIconsInfo});

  factory Category.fromMap(Map <String, dynamic> respData){
    return Category(
        id: respData['id'],
        name: respData['name'],
        categoryIconsInfo: [for (Map<String, dynamic> iconInfoMap in respData['icons']) CategoryIconInfo.fromMap(iconInfoMap)]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icons': categoryIconsInfo.map((iconInfo) => iconInfo.toJson()).toList(),
    };
  }

}

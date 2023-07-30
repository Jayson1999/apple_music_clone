import 'package:apple_music_clone/model/category_icon_info.dart';


class Category {
  final String id;
  final String name;
  final List<CategoryIconInfo> categoryIconsInfo;

  Category(this.id, this.name, this.categoryIconsInfo);

  factory Category.fromMap(Map <String, dynamic> respData){
    List<CategoryIconInfo> icons = (respData['icons'] as List?)?.map<CategoryIconInfo>((iconMap) => CategoryIconInfo.fromMap(iconMap)).toList() ?? [];

    return Category(
        respData['id'] ?? '',
        respData['name'] ?? '',
        icons
    );
  }

}

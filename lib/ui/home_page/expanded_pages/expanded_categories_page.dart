import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/text_list_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';


class CategoriesExpandedPage extends StatelessWidget {
  const CategoriesExpandedPage({Key? key, required this.categoriesPlaylists, required this.categories}) : super(key: key);
  final List<Category> categories;
  final List<List<Playlist>> categoriesPlaylists;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Browse by Category', style: TextStyle(fontSize: AppConfig.mediumText),),
          elevation: 0,
          shape: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0.5
              )
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: _bodyContents(),
        ),
      ),
    );
  }

  Widget _bodyContents(){
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: categoriesPlaylists.length,
      itemBuilder: (context, index) {
        String title = categories[index].name;

        return TextListItem(
          title: title,
          detailsPageRoute: AppRoutes.categoryDetailsPage,
          detailsPageArgs: CategoryDetailsArguments(title, categoriesPlaylists[index]),
        );
      },
    );
  }
}

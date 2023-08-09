import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/category_details_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/text_list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CategoriesExpandedPage extends StatelessWidget {
  const CategoriesExpandedPage({Key? key, required this.categoriesPlaylists, required this.categories}) : super(key: key);
  final List<Category> categories;
  final List<List<Playlist>> categoriesPlaylists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse by Category', style: TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        shape: const Border(
            bottom: BorderSide(
                color: Colors.grey,
                width: 0.5
            )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
        child: _bodyContents(),
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
        var detailsPage = BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(),
            child: CategoryDetailsPage(title: title, dataList: categoriesPlaylists[index])
        );

        return TextListItem(title: title, detailsPage: detailsPage);
      },
    );
  }
}

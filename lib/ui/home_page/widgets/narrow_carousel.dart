import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/category_details_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/narrow_tinted_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NarrowCarousel extends StatelessWidget {
  const NarrowCarousel({Key? key, required this.headerTitle, required this.dataList, required this.detailsDataList}) : super(key: key);

  final String headerTitle;
  final List<Category> dataList;
  final List<List<Playlist>> detailsDataList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(headerTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.5),
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (context, pageIndex) {
                return NarrowTintedItem(
                  title: dataList[pageIndex].name,
                  imgUrl: dataList[pageIndex].categoryIconsInfo.first.url,
                  detailsPage: BlocProvider<CategoryBloc>(
                      create: (context) => CategoryBloc(),
                      child: CategoryDetailsPage(title: dataList[pageIndex].name, dataList: detailsDataList[pageIndex])
                  )
                );
              }),
        )
      ],
    );
  }

}

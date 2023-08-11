import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/wide_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';


class WideCarousel extends StatelessWidget {
  const WideCarousel({Key? key, required this.dataList}) : super(key: key);

  final List dataList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          scrollDirection: Axis.horizontal,
          itemCount: dataList.length,
          itemBuilder: (context, index) => _wideItemFromData(dataList[index])
      ),
    );
  }

  Widget _wideItemFromData(var dataItem){
    String description = '';
    String title = '';
    String subtitle = '';
    String imgUrl = '';
    String overlayText = '';
    String detailsPageRoute = '';
    dynamic detailsPageArgs;

    switch (dataItem.type){
      case 'album':
        description = dataItem.type;
        title = dataItem.name;
        subtitle = dataItem.genres.join(',');
        imgUrl = dataItem.images.first.url;
        overlayText = '${dataItem.releaseDate}, ${dataItem.totalTracks}';
        detailsPageRoute = AppRoutes.albumDetailsPage;
        detailsPageArgs = AlbumDetailsArguments(dataItem.id);
        break;
      case 'playlist':
        description = dataItem.type;
        title = dataItem.name;
        subtitle = dataItem.description.split(' ').first;
        imgUrl = dataItem.images.first.url;
        overlayText = dataItem.description;
        detailsPageRoute = AppRoutes.playlistDetailsPage;
        detailsPageArgs = PlaylistDetailsArguments(dataItem.id);
        break;
    }

    return WideItem(
      description: description,
      title: title,
      subtitle: subtitle,
      imgUrl: imgUrl,
      overlayText: overlayText,
      detailsPageRoute: detailsPageRoute,
      detailsPageArgs: detailsPageArgs,
    );
  }

}

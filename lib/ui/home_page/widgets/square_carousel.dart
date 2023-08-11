import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/square_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';


class SquareCarousel extends StatelessWidget {
  const SquareCarousel({Key? key, required this.headerButtonTitle, required this.dataList, this.trailingWidget}) : super(key: key);

  final String headerButtonTitle;
  final List dataList;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: ()=> Navigator.pushNamed(
            context,
            AppRoutes.albumsExpandedPage,
            arguments: AlbumsPlaylistsExpandedArguments(headerButtonTitle, dataList)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.secondary,),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailingWidget,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (context, index) => _squareItemFromData(dataList[index])
          ),
        ),
      ],
    );
  }

  Widget _squareItemFromData(var dataItem){
    String title = '';
    String subtitle = '';
    String imgUrl = '';
    String overlayText = '';
    String detailsPageRoute = '';
    dynamic detailsPageArgs;

    switch (dataItem.type){
      case 'album':
        title = dataItem.name;
        subtitle = dataItem.genres.join(',');
        imgUrl = dataItem.images.first.url;
        overlayText = '${dataItem.releaseDate}, ${dataItem.totalTracks}';
        detailsPageRoute = AppRoutes.albumDetailsPage;
        detailsPageArgs = AlbumDetailsArguments(dataItem.id);
        break;
      case 'playlist':
        title = dataItem.name;
        subtitle = dataItem.description;
        imgUrl = dataItem.images.first.url;
        detailsPageRoute = AppRoutes.playlistDetailsPage;
        detailsPageArgs = PlaylistDetailsArguments(dataItem.id);
        break;
    }

    return SquareItem(
        title: title,
        subtitle: subtitle,
        imgUrl: imgUrl,
        overlayText: overlayText,
        detailsPageRoute: detailsPageRoute,
        detailsPageArgs: detailsPageArgs);
  }

}

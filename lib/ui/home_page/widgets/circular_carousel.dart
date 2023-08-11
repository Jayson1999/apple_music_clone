import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_item.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:flutter/material.dart';


class CircularCarousel extends StatelessWidget {
  const CircularCarousel({Key? key, required this.headerButtonTitle, required this.dataList}) : super(key: key);

  final String headerButtonTitle;
  final List dataList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.artistsExpandedPage,
            arguments: ArtistsExpandedArguments(headerButtonTitle, dataList)
        ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
              const Icon(Icons.chevron_right, color: Colors.grey,)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.32),
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (context, pageIndex) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.artistDetailsPage,
                      arguments: ArtistDetailsArguments(dataList[pageIndex])
                  ),
                  child: CircularItem(
                      title: dataList[pageIndex].name,
                      imgUrl: dataList[pageIndex].images.isNotEmpty? dataList[pageIndex].images.first.url : AppConfig.placeholderImgUrl
                  ),
                );
              }),
        )
      ],
    );
  }

}

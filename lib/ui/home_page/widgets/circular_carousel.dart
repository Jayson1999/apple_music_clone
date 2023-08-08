import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/artist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/bloc/artist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/expanded_artists_page.dart';
import 'package:apple_music_clone/ui/home_page/widgets/circular_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistsExpandedPage(dataList: dataList, title: headerButtonTitle),
            ),
          ),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
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
                var detailsPage = BlocProvider<ArtistBloc>(
                    create: (context) => ArtistBloc(),
                    child: ArtistDetailsPage(artist: dataList[pageIndex])
                );
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => detailsPage,
                    ),
                  ),
                  child: CircularItem(
                      title: dataList[pageIndex].name,
                      imgUrl: dataList[pageIndex].images.first.url
                  ),
                );
              }),
        )
      ],
    );
  }

}

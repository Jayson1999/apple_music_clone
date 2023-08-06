import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget squareGridItem(BuildContext context, String headerButtonTitle, List dataList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
          onPressed: ()=>print('hello'),
          child: Row(
            children: [
              Text(headerButtonTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              const Icon(Icons.chevron_right, color: Colors.grey,)
            ],
          ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              String title = '';
              String subtitle = '';
              String imgUrl = '';
              String overlayText = '';
              dynamic detailsPage;

              switch (dataList[index].type){
                case 'album':
                  title = dataList[index].name;
                  subtitle = dataList[index].genre.join(',');
                  imgUrl = dataList[index].images.first.url;
                  overlayText = '${dataList[index].releaseDate}, ${dataList[index].totalTracks}';
                  detailsPage = BlocProvider<AlbumBloc>(
                      create: (context) => AlbumBloc(),
                      child: AlbumDetails(albumId: dataList[index].id,)
                  );
                  break;
                case 'playlist':
                  title = dataList[index].name;
                  subtitle = dataList[index].description;
                  imgUrl = dataList[index].images.first.url;
                  detailsPage = BlocProvider<PlaylistBloc>(
                      create: (context) => PlaylistBloc(),
                      child: PlaylistDetails(playlistId: dataList[index].id,)
                  );
                  break;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.3,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => detailsPage),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.51,
                              width: double.infinity,
                              imageUrl: imgUrl,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                            ),
                            overlayText.isNotEmpty ?
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  overlayText,
                                  style: const TextStyle(
                                      fontSize: AppConfig.smallText,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                                : Container()
                          ],
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.grey),),
                  ),
                ],
              );
            }
        ),
      ),
    ],
  );
}
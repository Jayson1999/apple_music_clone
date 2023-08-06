import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumPlaylistExpandedPage extends StatelessWidget {
  const AlbumPlaylistExpandedPage({Key? key, required this.dataList, required this.title}) : super(key: key);
  final String title;
  final List dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.black),),
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
        padding: const EdgeInsets.all(8.0),
        child: _bodyContents(),
      ),
    );
  }

  Widget _bodyContents(){
    return GridView.builder(
      clipBehavior: Clip.hardEdge,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 200
      ),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        String title;
        String subtitle;
        String url;
        dynamic detailsPage;

        switch(dataList[index].type){
          case 'album':
            subtitle = [for (Artist a in dataList[index].artists) a.name].join(',');
            title = dataList[index].name;
            url = dataList[index].images.first.url;
            detailsPage = BlocProvider<AlbumBloc>(
                create: (context) => AlbumBloc(),
                child: AlbumDetails(albumId: dataList[index].id)
            );
            break;
          case 'playlist':
            subtitle = dataList[index].description;
            title = dataList[index].name;
            url = dataList[index].images.first.url;
            detailsPage = BlocProvider<PlaylistBloc>(
                create: (context) => PlaylistBloc(),
                child: PlaylistDetails(playlistId: dataList[index].id)
            );
            break;
          default:
            subtitle = '';
            title = '';
            url = '';
        }

        return InkWell(
          onTap: ()=> Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => detailsPage),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width*0.3,
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                ),
              ),
              Text(title, style: const TextStyle(fontSize: AppConfig.mediumText), overflow: TextOverflow.ellipsis,),
              Text(subtitle, style: const TextStyle(fontSize: AppConfig.mediumText, color: Colors.grey), overflow: TextOverflow.ellipsis,)
            ],
          ),
        );
      },
    );
  }
}

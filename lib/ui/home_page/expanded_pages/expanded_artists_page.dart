import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/artist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/bloc/artist_bloc.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ArtistsExpandedPage extends StatelessWidget {
  const ArtistsExpandedPage({Key? key, required this.dataList, required this.title}) : super(key: key);
  final String title;
  final List dataList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText),),
          elevation: 0,
          shape: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0.5
              )
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _bodyContents(),
        ),
      ),
    );
  }

  Widget _bodyContents(){
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        String title = dataList[index].name;
        String url = dataList[index].images.first.url;
        var detailsPage = BlocProvider<ArtistBloc>(
            create: (context) => ArtistBloc(),
            child: ArtistDetailsPage(artist: dataList[index])
        );

        return InkWell(
          onTap: ()=> Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => detailsPage),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  imageUrl: url,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
                ),
              ),
            ),
            title: Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: index!=dataList.length-1? Theme.of(context).colorScheme.secondary: Colors.transparent, width: 0.5),
                    )
                ),
                child: Text(title, style: const TextStyle(fontSize: AppConfig.mediumText))
            )
          ),
        );
      },
    );
  }
}

import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class TracksExpandedPage extends StatelessWidget {
  const TracksExpandedPage({Key? key, required this.dataList, required this.title}) : super(key: key);
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
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        String title = dataList[index].name;
        String subtitle = [for (Artist a in dataList[index].artists) a.name].join(',');
        String url = dataList[index].album?.images.first.url ?? '';
        // TracksDetails detailsPage =

        return InkWell(
          onTap: ()=> print('hello'),
          //     Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => detailsPage),
          // ),
          child: ListTile(
              leading: CachedNetworkImage(
                height: 40,
                width: 40,
                imageUrl: url,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
              ),
              title: Text(title, style: const TextStyle(color: Colors.black, fontSize: AppConfig.mediumText), overflow: TextOverflow.ellipsis,),
              subtitle: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: index!=dataList.length-1? Colors.grey: Colors.white, width: 0.5),
                      )
                  ),
                  child: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: AppConfig.smallText), overflow: TextOverflow.ellipsis),
              ),
          ),
        );
      },
    );
  }
}

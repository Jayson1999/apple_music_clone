import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.title, required this.subtitle, required this.listTileSize, required this.imgSize, required this.imgUrl, required this.showBtmBorder}) : super(key: key);

  final String title;
  final String subtitle;
  final String imgUrl;
  final double listTileSize;
  final double imgSize;
  final bool showBtmBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: listTileSize,
        child: ListTile(
          leading: CachedNetworkImage(
            height: imgSize,
            width: imgSize,
            imageUrl: imgUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          ),
          title: Text(title, style: const TextStyle(color: Colors.black, fontSize: AppConfig.smallText)),
          subtitle: Container(
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: showBtmBorder? Colors.grey: Colors.white, width: 0.5),
                  )
              ),
              child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: AppConfig.smallText)
              )
          ),
        ),
      ),
    );
  }

}

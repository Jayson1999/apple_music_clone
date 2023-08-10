import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ListItem extends StatelessWidget {
  const ListItem({Key? key, required this.title, required this.subtitle, required this.listTileSize, required this.imgSize, required this.imgUrl, required this.showBtmBorder, this.trailingWidget}) : super(key: key);

  final String title;
  final String subtitle;
  final String imgUrl;
  final double listTileSize;
  final double imgSize;
  final bool showBtmBorder;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
      child: SizedBox(
        height: listTileSize,
        child: ListTile(
          leading: CachedNetworkImage(
            height: imgSize,
            width: imgSize,
            imageUrl: imgUrl,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
          ),
          title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: AppConfig.mediumText)
          ),
          subtitle: Container(
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: showBtmBorder? Colors.grey: Colors.white, width: 0.5),
                  )
              ),
              child: Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: AppConfig.smallText)
              )
          ),
          trailing: trailingWidget,
        ),
      ),
    );
  }

}

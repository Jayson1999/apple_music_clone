import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget singleTrack(Track trackData, BuildContext context){
  return ListTile(
    leading: CachedNetworkImage(
      imageUrl: trackData.album?.images[0].url ?? '',
      width: 30,
      errorWidget: (context, url, error) =>
      const Center(child: Icon(Icons.error)),
    ),
    title: Text(
      trackData.name,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: AppConfig.mediumText),
    ),
    subtitle: Text(
      '${trackData.type} . ${[for (Artist a in trackData.artists) a.name].join(',')}',
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.grey),
    ),
    trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor,),
        onSelected: (value) => print('hello'),
        itemBuilder: (BuildContext context) =>
        <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'settings',
            child: Text('Settings'),
          ),
        ]
    ),
  );
}
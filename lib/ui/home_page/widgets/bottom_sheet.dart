import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({Key? key, required this.title, required this.subtitle, required this.imgUrl, required this.type}) : super(key: key);

  final String title;
  final String subtitle;
  final String imgUrl;
  final String type;

  @override
  Widget build(BuildContext context) {
    String typeName = '${type[0].toUpperCase()}${type.substring(1)}';
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        children: [
          ListTile(
            shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 0.5
              )
            ),
            leading: CachedNetworkImage(imageUrl: imgUrl, width: 40, height: 40,),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.secondary), overflow: TextOverflow.ellipsis,),
            onTap: ()=> print('hello'),
          ),
          ListTile(
            leading: Icon(Icons.queue_play_next, color: Theme.of(context).colorScheme.primary,),
            title: const Text('Play Next'),
            onTap: ()=> print('hello'),
          ),
          ListTile(
            leading: Icon(Icons.playlist_play, color: Theme.of(context).colorScheme.primary,),
            title: const Text('Play Last'),
            onTap: ()=>print('hello'),
          ),
          ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).colorScheme.primary,),
            title: Text('Share $typeName'),
            onTap: ()=>print('hello'),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton.icon(
                      onPressed: ()=>print('hello'),
                      icon: const Icon(Icons.heart_broken),
                      label: const Text('Love'),
                      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                      onPressed: ()=>print('hello'),
                      icon: const Icon(Icons.heart_broken_outlined),
                      label: const Text('Dislike'),
                      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

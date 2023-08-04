import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/bloc/search_bloc.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  final SearchBloc searchBloc;

  SearchBarDelegate(this.searchBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // searchBloc.add(SearchTextChanged(query));
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      searchBloc.add(SearchTextChanged(query));
      return BlocBuilder<SearchBloc, SearchState>(
        bloc: searchBloc,
        builder: (context, state) {
          if (state.searchStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else if (state.searchStatus.isSuccess) {
            return ListView.builder(
                itemCount: state.searchedResults.length,
                itemBuilder: (context, index){
                  final currentItem = state.searchedResults[index];
                  switch (currentItem.type){
                    case 'artist':
                      return _singleArtist(currentItem);
                    case 'album':
                      return _singleAlbum(currentItem);
                    case 'playlist':
                      return _singlePlaylist(currentItem);
                    case 'track':
                      return _singleTrack(currentItem, context);
                  }
                });
          }

          else if (state.searchStatus.isError) {
            return Center(
              child: Text('Failed to fetch data: ${state.errorMsg}'),
            );
          }

          return Text('$state');
        },
      );
    }
  }


  Widget _singleTrack(Track trackData, BuildContext context){
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
        style: const TextStyle(fontSize: TextSizes.medium),
      ),
      subtitle: Text(
        '${trackData.type} . ${[for (Artist a in trackData.artists) a.name].join(',')}',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: TextSizes.small, color: Colors.grey),
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

  Widget _singleArtist(Artist artistData){
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: artistData.images.isNotEmpty ? artistData.images[0].url : '',
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
      title: Text(
        artistData.name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: TextSizes.medium),
      ),
      subtitle: Text(
       artistData.type,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: TextSizes.small, color: Colors.grey),
      )
    );
  }

  Widget _singlePlaylist(Playlist playlistData){
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: playlistData.images[0].url,
        width: 30,
        errorWidget: (context, url, error) =>
        const Center(child: Icon(Icons.error)),
      ),
      title: Text(
        playlistData.name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: TextSizes.medium),
      ),
      subtitle: Text(
        '${playlistData.type} . ${playlistData.tracks.length} tracks',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: TextSizes.small, color: Colors.grey),
      )
    );
  }

  Widget _singleAlbum(Album albumData){
    return ListTile(
        leading: CachedNetworkImage(
          imageUrl: albumData.images[0].url,
          width: 30,
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
        ),
        title: Text(
          albumData.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.medium),
        ),
        subtitle: Text(
          '${albumData.type} . ${[for (Artist a in albumData.artists) a.name].join(',')}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: TextSizes.small, color: Colors.grey),
        )
    );
  }



}
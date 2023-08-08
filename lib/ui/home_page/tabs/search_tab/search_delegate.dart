import 'package:apple_music_clone/model/album.dart';
import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';
import 'package:apple_music_clone/model/track.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/artist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/bloc/artist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/tabs/search_tab/bloc/search_bloc.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchBarDelegate extends SearchDelegate<String> {
  final SearchBloc searchBloc;
  final String searchHint;

  SearchBarDelegate(this.searchBloc, this.searchHint): super(
    searchFieldLabel: searchHint,
    searchFieldStyle: const TextStyle(color: Colors.grey)
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).primaryColor,),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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
          if (state.searchStatus.isLoading || state.searchStatus.isInitial) {
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
                      return _singleArtist(context, currentItem);
                    case 'album':
                      return _singleAlbum(context, currentItem);
                    case 'playlist':
                      return _singlePlaylist(context, currentItem);
                    case 'track':
                      return _singleTrack(context, currentItem);
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

  Widget _singleArtist(BuildContext context, Artist artistData){
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlocProvider<ArtistBloc>(
            create: (context) => ArtistBloc(),
            child: ArtistDetailsPage(artist: artistData)
        )),
      ),
      child: ListTile(
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
          style: const TextStyle(fontSize: AppConfig.mediumText),
        ),
        subtitle: Text(
         artistData.type,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.grey),
        )
      ),
    );
  }

  Widget _singlePlaylist(BuildContext context, Playlist playlistData){
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlocProvider<PlaylistBloc>(
            create: (context) => PlaylistBloc(),
            child: PlaylistDetails(playlistId: playlistData.id)
        )),
      ),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: playlistData.images[0].url,
          width: 30,
          errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
        ),
        title: Text(
          playlistData.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.mediumText),
        ),
        subtitle: Text(
          '${playlistData.type} . ${playlistData.tracks.length} tracks',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.grey),
        )
      ),
    );
  }

  Widget _singleAlbum(BuildContext context, Album albumData){
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlocProvider<AlbumBloc>(
            create: (context) => AlbumBloc(),
            child: AlbumDetails(albumId: albumData.id,)
        )),
      ),
      child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: albumData.images.first.url,
            width: 30,
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          ),
          title: Text(
            albumData.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppConfig.mediumText),
          ),
          subtitle: Text(
            '${albumData.type} . ${[for (Artist a in albumData.artists) a.name].join(',')}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: AppConfig.smallText, color: Colors.grey),
          )
      ),
    );
  }

  Widget _singleTrack(BuildContext context,Track trackData){
    return ListItem(
      title: trackData.name,
      subtitle: '${trackData.type} . ${[for (Artist a in trackData.artists) a.name].join(',')}',
      listTileSize: MediaQuery.of(context).size.height * 0.1,
      imgSize: 30,
      imgUrl: trackData.album?.images.first.url ?? '',
      showBtmBorder: false,
      trailingWidget: PopupMenuButton<String>(
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

}
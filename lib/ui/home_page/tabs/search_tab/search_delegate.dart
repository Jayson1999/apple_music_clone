import 'dart:convert';
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
import 'package:apple_music_clone/ui/home_page/widgets/bottom_sheet.dart';
import 'package:apple_music_clone/ui/home_page/widgets/list_item.dart';
import 'package:apple_music_clone/utils/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchBarDelegate extends SearchDelegate<String> {
  final SearchBloc searchBloc;
  final String searchHint;
  final List<String> searchHistories;

  SearchBarDelegate(this.searchBloc, this.searchHint, this.searchHistories): super(
    searchFieldLabel: searchHint,
    searchFieldStyle: const TextStyle(color: Colors.grey)
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary,),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

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
          return DefaultTabController(
            length: 5,
            child: SafeArea(
              child: Scaffold(
                appBar: TabBar(
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                    labelColor: Theme.of(context).colorScheme.primary,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'TOP RESULTS'),
                      Tab(text: 'ARTISTS'),
                      Tab(text: 'ALBUMS'),
                      Tab(text: 'SONGS'),
                      Tab(text: 'PLAYLISTS'),
                    ],
                  ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: _getResultsTabs(state.searchedResults)
                ),
              ),
            ),
          );
        }

        else if (state.searchStatus.isError) {
          return Center(
            child: Text('Build Search Results failed: ${state.errorMsg}'),
          );
        }

        return Text('$state');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return searchHistories.isNotEmpty? _recentSearches(context): Container();
    }

    searchBloc.add(SearchTextChanged(query));
    return _suggestions();
  }

  List<Widget> _getResultsTabs(List allResults) {
    List artistResults = [for(dynamic result in allResults) if (result.type=='artist') result ];
    List albumResults = [for(dynamic result in allResults) if (result.type=='album') result ];
    List songResults = [for(dynamic result in allResults) if (result.type=='track') result ];
    List playlistResults = [for(dynamic result in allResults) if (result.type=='playlist') result ];

    List<List> allTabResults = [allResults, artistResults, albumResults, songResults, playlistResults];
    return [
      for (List eachTabResults in allTabResults)
        ListView.builder(
            itemCount: eachTabResults.length,
            itemBuilder: (context, index){
              final currentItem = eachTabResults[index];
              return _getWidgetFromData(context, currentItem);
            })
    ];
  }

  Widget _recentSearches(BuildContext context){
    Widget header = ListTile(
      title: const Text(
        'Recently Searched',
        style: TextStyle( fontWeight: FontWeight.bold, fontSize: AppConfig.mediumText),),
      trailing: TextButton(
        style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
        onPressed: () => SharedPreferences.getInstance().then((value) {
          value.remove('searchHistories');
          searchHistories.clear();
          showSuggestions(context);
        }),
        child: const Text('Clear'),
      ),
    );

    List<Widget> historyWidgets = [];
    for (String currentHistory in searchHistories.reversed.toList()) {
      List<String> splitData = currentHistory.split(';;;');
      final String currentType = splitData.first;
      dynamic currentItem;

      switch (currentType){
        case 'artist':
          currentItem = Artist.fromMap(json.decode(splitData.last));
          break;

        case 'album':
          currentItem = Album.fromMap(json.decode(splitData.last));
          break;

        case 'playlist':
          currentItem = Playlist.fromMap(json.decode(splitData.last));
          break;

        default:
          currentItem = Track.fromMap(json.decode(splitData.last));
      }

      historyWidgets.add(_getWidgetFromData(context, currentItem));
    }

    return ListView(
      children: [
        header,
        ...historyWidgets
      ],
    );
  }

  Widget _suggestions(){
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state.searchStatus.isLoading || state.searchStatus.isInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        else if (state.searchStatus.isSuccess) {
          const int noOfSuggestionText = 3;
          List suggestions = state.searchedResults;
          List top3Suggestions = suggestions.sublist(suggestions.length-noOfSuggestionText, suggestions.length);
          List allSuggestions = [...top3Suggestions, ...suggestions];

          return ListView.builder(
              itemCount: allSuggestions.length,
              itemBuilder: (context, index){
                final currentItem = allSuggestions[index];

                if (index < noOfSuggestionText){
                  return _suggestedSearchItem(context, currentItem.name);
                }
                return _getWidgetFromData(context, currentItem);
              });
        }

        else if (state.searchStatus.isError) {
          return Center(
            child: Text('Build Search Suggestions failed: ${state.errorMsg}'),
          );
        }

        return Text('$state');
      },
    );
  }

  Widget _suggestedSearchItem(BuildContext context, String suggestedText){
    final formattedSuggestionText = _formatSuggestion(suggestedText, query);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
      child: InkWell(
        onTap: () {
          query = suggestedText;
          showResults(context);
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5),
                )
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, color: Theme.of(context).colorScheme.secondary,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(formattedSuggestionText, overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  TextSpan _formatSuggestion(String suggestionText, String queryText) {
    final suggestionLower = suggestionText.toLowerCase();
    final queryLower = queryText.toLowerCase();

    int matchStart = suggestionLower.indexOf(queryLower);
    if (matchStart == -1) {
      return TextSpan(text: suggestionText);
    }

    final List<TextSpan> spans = [];

    if (matchStart > 0) {
      spans.add(TextSpan(text: suggestionText.substring(0, matchStart), style: const TextStyle(color: Colors.grey)));
    }

    spans.add(TextSpan(
        text: suggestionText.substring(matchStart, matchStart + queryText.length)
    ));

    if (matchStart + queryText.length < suggestionText.length) {
      spans.add(TextSpan(text: suggestionText.substring(matchStart + queryText.length), style: const TextStyle(color: Colors.grey)));
    }

    return TextSpan(children: spans);
  }

  Widget _getWidgetFromData(BuildContext context, var currentItem){
    switch (currentItem.type){
      case 'artist':
        return _singleArtist(context, currentItem);

      case 'album':
        return _singleAlbum(context, currentItem);

      case 'playlist':
        return _singlePlaylist(context, currentItem);

      case 'track':
        return _singleTrack(context, currentItem);

      default:
        return const Text('Unrecognized Type of item passed to _getItemFromData');
    }
  }

  Widget _singleArtist(BuildContext context, Artist artistData){
    return ListTile(
      onTap: () =>
          SharedPreferences.getInstance().then((value) {
            String historyToBeAdded = 'artist;;;${jsonEncode(artistData)}';
            if (searchHistories.contains(historyToBeAdded)){
              searchHistories.remove(historyToBeAdded);
            }
            searchHistories.add(historyToBeAdded);
            value.setStringList('searchHistories', searchHistories);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlocProvider<ArtistBloc>(
                  create: (context) => ArtistBloc(),
                  child: ArtistDetailsPage(artist: artistData)
              )),
            );
          }),
      leading: CircleAvatar(
        radius: 20,
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: artistData.images.isNotEmpty ? artistData.images[0].url : '',
            errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
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
        style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
      )
    );
  }

  Widget _singlePlaylist(BuildContext context, Playlist playlistData){
    return ListTile(
      onTap: () =>
          SharedPreferences.getInstance().then((value) {
            String historyToBeAdded = 'playlist;;;${jsonEncode(playlistData)}';
            if (searchHistories.contains(historyToBeAdded)){
              searchHistories.remove(historyToBeAdded);
            }
            searchHistories.add(historyToBeAdded);
            value.setStringList('searchHistories', searchHistories);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  BlocProvider<PlaylistBloc>(
                      create: (context) => PlaylistBloc(),
                      child: PlaylistDetails(playlistId: playlistData.id)
                  )
              ),
            );
          }),
      leading: CachedNetworkImage(
        imageUrl: playlistData.images.isNotEmpty? playlistData.images.first.url: AppConfig.placeholderImgUrl,
        width: 40,
        errorWidget: (context, url, error) =>
        CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
      ),
      title: Text(
        playlistData.name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: AppConfig.mediumText),
      ),
      subtitle: Text(
        '${playlistData.type} . ${playlistData.tracks.length} tracks',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
      )
    );
  }

  Widget _singleAlbum(BuildContext context, Album albumData){
    return ListTile(
        onTap: () => SharedPreferences.getInstance().then((value) {
          String historyToBeAdded = 'album;;;${jsonEncode(albumData)}';
          if (searchHistories.contains(historyToBeAdded)){
            searchHistories.remove(historyToBeAdded);
          }
          searchHistories.add(historyToBeAdded);
          value.setStringList('searchHistories', searchHistories);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider<AlbumBloc>(
                    create: (context) => AlbumBloc(),
                    child: AlbumDetails(
                      albumId: albumData.id,
                    ))),
          );
        }),
        leading: CachedNetworkImage(
          imageUrl: albumData.images.isNotEmpty? albumData.images.first.url: AppConfig.placeholderImgUrl,
          width: 40,
          errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: AppConfig.placeholderImgUrl),
        ),
        title: Text(
          albumData.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: AppConfig.mediumText),
        ),
        subtitle: Text(
          '${albumData.type} . ${[for (Artist a in albumData.artists) a.name].join(',')}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: AppConfig.smallText, color: Theme.of(context).colorScheme.secondary),
        )
    );
  }

  Widget _singleTrack(BuildContext context, Track trackData){
    String title = trackData.name;
    String subtitle = '${trackData.type} . ${[for (Artist a in trackData.artists) a.name].join(',')}';
    String imgUrl = trackData.album?.images.first.url ?? AppConfig.placeholderImgUrl;

    return InkWell(
      onTap: () => SharedPreferences.getInstance().then((value) {
        String historyToBeAdded = 'track;;;${jsonEncode(trackData)}';
        if (searchHistories.contains(historyToBeAdded)){
          searchHistories.remove(historyToBeAdded);
        }
        searchHistories.add(historyToBeAdded);
        value.setStringList('searchHistories', searchHistories);
      }),
      child: ListItem(
        title: title,
        subtitle: subtitle,
        listTileSize: MediaQuery.of(context).size.height * 0.1,
        imgSize: 40,
        imgUrl: imgUrl,
        showBtmBorder: false,
        trailingWidget: IconButton(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary,),
          onPressed: (){
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                builder: (context){
                  return BottomSheetLayout(
                      title: title,
                      subtitle: subtitle,
                      imgUrl: imgUrl,
                      type: 'song'
                  );
                });
          },
        ),
      ),
    );
  }

}
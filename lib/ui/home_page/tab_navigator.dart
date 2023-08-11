import 'package:apple_music_clone/ui/home_page/details_pages/album_details/album_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/album_details/bloc/album_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/artist_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/artist_details/bloc/artist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/bloc/category_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/category_details/category_details_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/details_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_album_playlist_page.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_artists_page.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_categories_page.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_pages_args.dart';
import 'package:apple_music_clone/ui/home_page/expanded_pages/expanded_tracks_page.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/bloc/playlist_bloc.dart';
import 'package:apple_music_clone/ui/home_page/details_pages/playlist_details/playlist_details_page.dart';
import 'package:apple_music_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key, required this.currentTab, required this.navigatorKey}) : super(key: key);
  final Widget currentTab;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (RouteSettings settings){
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context){
                switch (settings.name){
                  // Tabs
                  case '/':
                    return widget.currentTab;

                  // Details Pages
                  case AppRoutes.albumDetailsPage:
                    final args = settings.arguments as AlbumDetailsArguments;
                    return BlocProvider<AlbumBloc>(
                        create: (context) => AlbumBloc(),
                        child: AlbumDetails(albumId: args.albumId)
                    );
                  case AppRoutes.playlistDetailsPage:
                    final args = settings.arguments as PlaylistDetailsArguments;
                    return BlocProvider<PlaylistBloc>(
                        create: (context) => PlaylistBloc(),
                        child: PlaylistDetails(playlistId: args.playlistId)
                    );
                  case AppRoutes.artistDetailsPage:
                    final args = settings.arguments as ArtistDetailsArguments;
                    return BlocProvider<ArtistBloc>(
                        create: (context) => ArtistBloc(),
                        child: ArtistDetailsPage(artist: args.artist)
                    );
                  case AppRoutes.categoryDetailsPage:
                    final args = settings.arguments as CategoryDetailsArguments;
                    return BlocProvider<CategoryBloc>(
                        create: (context) => CategoryBloc(),
                        child: CategoryDetailsPage(title: args.title, dataList: args.dataList)
                    );

                  // Expanded Pages
                  case AppRoutes.albumsExpandedPage:
                  case AppRoutes.playlistsExpandedPage:
                    final args = settings.arguments as AlbumsPlaylistsExpandedArguments;
                    return AlbumPlaylistExpandedPage(dataList: args.dataList, title: args.title);
                  case AppRoutes.artistsExpandedPage:
                    final args = settings.arguments as ArtistsExpandedArguments;
                    return ArtistsExpandedPage(dataList: args.dataList, title: args.title);
                  case AppRoutes.categoriesExpandedPage:
                    final args = settings.arguments as CategoriesExpandedArguments;
                    return CategoriesExpandedPage(categoriesPlaylists: args.categoriesPlaylists, categories: args.categories);
                  case AppRoutes.tracksExpandedPage:
                    final args = settings.arguments as TracksExpandedArguments;
                    return TracksExpandedPage(dataList: args.dataList, title: args.title);

                  default:
                    throw Exception('Unrecognized route ${settings.name} in Browse Tab!');
                }
              }
          );
        }
    );
  }
}

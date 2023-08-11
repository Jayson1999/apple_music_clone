import 'package:apple_music_clone/model/category.dart';
import 'package:apple_music_clone/model/playlist.dart';


class AlbumsPlaylistsExpandedArguments{
  final String title;
  final List dataList;

  AlbumsPlaylistsExpandedArguments(this.title, this.dataList);
}

class ArtistsExpandedArguments{
  final String title;
  final List dataList;

  ArtistsExpandedArguments(this.title, this.dataList);
}

class CategoriesExpandedArguments{
  final List<Category> categories;
  final List<List<Playlist>> categoriesPlaylists;

  CategoriesExpandedArguments(this.categories, this.categoriesPlaylists);
}

class TracksExpandedArguments{
  final String title;
  final List dataList;

  TracksExpandedArguments(this.title, this.dataList);
}

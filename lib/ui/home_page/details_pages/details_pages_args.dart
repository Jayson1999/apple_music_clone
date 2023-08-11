import 'package:apple_music_clone/model/artist.dart';
import 'package:apple_music_clone/model/playlist.dart';


class AlbumDetailsArguments{
  final String albumId;

  AlbumDetailsArguments(this.albumId);
}

class ArtistDetailsArguments{
  final Artist artist;

  ArtistDetailsArguments(this.artist);
}

class PlaylistDetailsArguments{
  final String playlistId;

  PlaylistDetailsArguments(this.playlistId);
}

class CategoryDetailsArguments{
  final String title;
  final List<Playlist> dataList;

  CategoryDetailsArguments(this.title, this.dataList);
}
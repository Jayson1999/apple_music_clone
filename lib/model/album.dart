class Album {
  String id;
  String type;
  AlbumAttributes attributes;

  Album({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      attributes: AlbumAttributes.fromMap(map['attributes'] ?? {}),
    );
  }
}

class AlbumAttributes {
  String copyright;
  List<String> genreNames;
  String releaseDate;
  String upc;
  bool isMasteredForItunes;

  AlbumAttributes({
    required this.copyright,
    required this.genreNames,
    required this.releaseDate,
    required this.upc,
    required this.isMasteredForItunes,
  });

  factory AlbumAttributes.fromMap(Map<String, dynamic> map) {
    return AlbumAttributes(
      copyright: map['copyright'] ?? '',
      genreNames: List<String>.from(map['genreNames'] ?? []),
      releaseDate: map['releaseDate'] ?? '',
      upc: map['upc'] ?? '',
      isMasteredForItunes: map['isMasteredForItunes'] ?? false,
    );
  }
}

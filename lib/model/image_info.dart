class ImageInfo {
  final String url;
  final int height;
  final int width;

  ImageInfo(this.url, this.height, this.width);

  factory ImageInfo.fromMap(Map<String, dynamic> map) {
    return ImageInfo(
      map['url'] ?? '',
      map['height'] ?? 0,
      map['width'] ?? 0,
    );
  }
}
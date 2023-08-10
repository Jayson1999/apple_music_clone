class ImageInfo {
  final String url;
  final int? height;
  final int? width;

  ImageInfo({required this.url, required this.height, required this.width});

  factory ImageInfo.fromMap(Map<String, dynamic> map) {
    return ImageInfo(
      url: map['url'],
      height: map['height'],
      width: map['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'height': height,
      'width': width,
    };
  }
}
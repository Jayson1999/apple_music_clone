class CategoryIconInfo {
  final String url;
  final int? height;
  final int? width;

  CategoryIconInfo({required this.url, required this.height, required this.width});

  factory CategoryIconInfo.fromMap(Map<String, dynamic> map) {
    return CategoryIconInfo(
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
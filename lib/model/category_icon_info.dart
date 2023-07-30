class CategoryIconInfo {
  final String url;
  final int height;
  final int width;

  CategoryIconInfo(this.url, this.height, this.width);

  factory CategoryIconInfo.fromMap(Map<String, dynamic> map) {
    return CategoryIconInfo(
      map['url'] ?? '',
      map['height'] ?? 0,
      map['width'] ?? 0,
    );
  }
}
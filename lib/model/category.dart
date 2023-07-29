class Category {
  final String id;
  final String name;

  Category(this.id, this.name);

  factory Category.fromMap(Map <String, dynamic> respData){
    return Category(
        respData['id'] ?? '',
        respData['name'] ?? ''
    );
  }

}

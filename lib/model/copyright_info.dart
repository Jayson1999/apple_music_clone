class CopyrightInfo {
  final String text;
  final String type;

  CopyrightInfo(this.text, this.type);

  factory CopyrightInfo.fromMap(Map<String, dynamic> map) {
    return CopyrightInfo(
      map['text'] ?? '',
      map['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
    };
  }
}
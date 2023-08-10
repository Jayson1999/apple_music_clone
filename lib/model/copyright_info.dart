class CopyrightInfo {
  final String text;
  final String type;

  CopyrightInfo({required this.text, required this.type});

  factory CopyrightInfo.fromMap(Map<String, dynamic> map) {
    return CopyrightInfo(
      text: map['text'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
    };
  }
}
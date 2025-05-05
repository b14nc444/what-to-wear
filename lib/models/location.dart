class Location {
  final String id;
  final String sido;
  final String sigungu;
  final String displayName;

  Location({
    required this.id,
    required this.sido,
    required this.sigungu,
    required this.displayName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      sido: json['sido'] as String,
      sigungu: json['sigungu'] as String,
      displayName: json['displayName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sido': sido,
      'sigungu': sigungu,
      'displayName': displayName,
    };
  }
}

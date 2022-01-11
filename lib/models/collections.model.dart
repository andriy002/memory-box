class CollectionsBuilder {
  String? descriptions;
  String? image;
  String? name;
  String? displayName;

  CollectionsBuilder(
      {this.descriptions, this.image, this.name, this.displayName});

  factory CollectionsBuilder.fromJson(Map<String, dynamic> json) {
    return CollectionsBuilder(
      descriptions: json['descriptions'],
      name: json['name'],
      image: json['image'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'descriptions': descriptions,
        'image': image,
        'name': name,
        'displayName': displayName
      };
}

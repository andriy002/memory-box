class CollectionsBuilder {
  String? descriptions;
  String? image;
  String? length;
  String? name;
  String? displayName;

  CollectionsBuilder(
      {this.descriptions,
      this.image,
      this.length,
      this.name,
      this.displayName});

  factory CollectionsBuilder.fromJson(Map<String, dynamic> json) {
    return CollectionsBuilder(
        descriptions: json['descriptions'],
        name: json['name'],
        image: json['image'],
        displayName: json['displayName'],
        length: json['length']);
  }

  Map<String, dynamic> toJson() => {
        'descriptions': descriptions,
        'image': image,
        'length': length,
        'name': name,
        'displayName': displayName
      };
}

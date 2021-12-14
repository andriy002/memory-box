class UserBuilder {
  String? displayName;
  String? phoneNumb;
  String? avatarUrl;

  UserBuilder({
    this.displayName,
    this.phoneNumb,
    this.avatarUrl,
  });

  factory UserBuilder.fromJson(Map<String, dynamic> json) {
    return UserBuilder(
      displayName: json['displayName'],
      phoneNumb: json['phoneNumb'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'phoneNumb': phoneNumb,
        'avatarUrl': avatarUrl
      };
}

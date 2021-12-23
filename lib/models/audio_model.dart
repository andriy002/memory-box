class AudioBuilder {
  String? uid;
  String? audioName;
  String? audioUrl;
  String? duration;
  List? collections;

  AudioBuilder(
      {this.uid,
      this.audioName,
      this.audioUrl,
      this.duration,
      this.collections});

  factory AudioBuilder.fromJson(Map<String, dynamic> json) {
    return AudioBuilder(
        uid: json['uid'],
        audioName: json['audioName'],
        audioUrl: json['audioUrl'],
        collections: json['collections'],
        duration: json['duration']);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'audioName': audioName,
        'audioUrl': audioUrl,
        'collections': collections,
        'duration': duration
      };
}

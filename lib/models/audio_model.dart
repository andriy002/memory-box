class AudioBuilder {
  String? uid;
  String? audioName;
  String? audioUrl;
  String? duration;

  AudioBuilder({
    this.uid,
    this.audioName,
    this.audioUrl,
    this.duration,
  });

  factory AudioBuilder.fromJson(Map<String, dynamic> json) {
    return AudioBuilder(
        uid: json['uid'],
        audioName: json['audioName'],
        audioUrl: json['audioUrl'],
        duration: json['duration']);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'audioName': audioName,
        'audioUrl': audioUrl,
        'duration': duration
      };
}

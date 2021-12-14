class AudioBuilder {
  String? audioName;
  String? audioUrl;
  String? duration;

  AudioBuilder({
    this.audioName,
    this.audioUrl,
    this.duration,
  });

  factory AudioBuilder.fromJson(Map<String, dynamic> json) {
    return AudioBuilder(
      audioName: json['audioName'],
      audioUrl: json['audioUrl'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() => {
        'audioName': audioName,
        'audioUrl': audioUrl,
        'duration': duration,
      };
}

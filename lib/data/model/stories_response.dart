import 'package:submission/data/model/story.dart';

class StoriesResponse {
  StoriesResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  bool error;
  String message;
  List<Story> story;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoriesResponse(
        error: json['error'],
        message: json['message'],
        story:
            List<Story>.from(json['listStory'].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'listStory': List<dynamic>.from(story.map((x) => x.toJson())),
      };
}

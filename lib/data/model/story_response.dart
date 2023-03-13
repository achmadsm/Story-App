import 'package:submission/data/model/story.dart';

class StoryResponse {
  StoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  bool error;
  String message;
  Story story;

  factory StoryResponse.fromJson(Map<String, dynamic> json) => StoryResponse(
        error: json['error'],
        message: json['message'],
        story: Story.fromJson(json['story']),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
        'story': story.toJson(),
      };
}

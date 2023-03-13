import 'package:flutter/foundation.dart';
import 'package:submission/data/model/story_response.dart';

import '../data/api/api_service.dart';
import '../data/db/auth_repository.dart';
import '../data/model/stories_response.dart';
import '../utils/result_state.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  StoryProvider(this.apiService, this.authRepository) {
    fetchListStory();
  }

  late StoriesResponse _storiesResponse;
  late StoryResponse _storyResponse;
  late ResultState _state;
  String _message = '';

  StoriesResponse get storiesResponse => _storiesResponse;

  StoryResponse get storyResponse => _storyResponse;

  ResultState get state => _state;

  String get message => _message;

  Future<dynamic> fetchListStory() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      String? token = await authRepository.getUser();

      final stories = await apiService.listStory(token!);
      debugPrint('Token $token');
      if (stories.story.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _storiesResponse = stories;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> fetchDetailStory(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      String? token = await authRepository.getUser();

      final story = await apiService.detailStory(token!, id);

      if (story.story.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _storyResponse = story;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

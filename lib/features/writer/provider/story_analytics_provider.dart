import 'package:flutter/foundation.dart';

import '../models/story_analytics_model.dart';
import '../services/story_analytics_service.dart';

class StoryAnalyticsProvider extends ChangeNotifier {
  StoryAnalyticsProvider({StoryAnalyticsService? service})
      : _service = service ?? StoryAnalyticsService();

  final StoryAnalyticsService _service;

  bool isLoading = false;
  String? errorMessage;
  StoryAnalyticsModel? analytics;
  List<ChapterAnalyticsModel> chapters = [];
  List<GrowthAnalyticsModel> weeklyGrowth = [];
  String? _storyId;

  Future<void> fetchStoryAnalytics(String storyId) async {
    if (storyId.isEmpty) {
      errorMessage = 'Story id is missing.';
      notifyListeners();
      return;
    }

    _storyId = storyId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        _service.fetchOverview(storyId),
        _service.fetchChapters(storyId),
        _service.fetchWeeklyGrowth(storyId),
      ]);

      analytics = results[0] as StoryAnalyticsModel;
      chapters = results[1] as List<ChapterAnalyticsModel>;
      weeklyGrowth = results[2] as List<GrowthAnalyticsModel>;
    } catch (error) {
      debugPrint('fetchStoryAnalytics error: $error');
      errorMessage = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Unable to load story analytics.';
      analytics = null;
      chapters = [];
      weeklyGrowth = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAnalytics() async {
    final currentId = _storyId;
    if (currentId == null || currentId.isEmpty) {
      return;
    }
    await fetchStoryAnalytics(currentId);
  }
}

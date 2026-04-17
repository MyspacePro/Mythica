class StoryAnalyticsModel {
  const StoryAnalyticsModel({
    this.totalViews = 0,
    this.uniqueReaders = 0,
    this.completionRate = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.totalShares = 0,
    this.followersGained = 0,
    this.totalReadingMinutes = 0,
  });

  final int totalViews;
  final int uniqueReaders;
  final double completionRate;
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final int followersGained;
  final int totalReadingMinutes;

  factory StoryAnalyticsModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return StoryAnalyticsModel(
      totalViews: (data['totalViews'] as num?)?.toInt() ?? 0,
      uniqueReaders: (data['uniqueReaders'] as num?)?.toInt() ?? 0,
      completionRate: (data['completionRate'] as num?)?.toDouble() ?? 0,
      totalLikes: (data['totalLikes'] as num?)?.toInt() ?? 0,
      totalComments: (data['totalComments'] as num?)?.toInt() ?? 0,
      totalShares: (data['totalShares'] as num?)?.toInt() ?? 0,
      followersGained: (data['followersGained'] as num?)?.toInt() ?? 0,
      totalReadingMinutes: (data['totalReadingMinutes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalViews': totalViews,
      'uniqueReaders': uniqueReaders,
      'completionRate': completionRate,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'totalShares': totalShares,
      'followersGained': followersGained,
      'totalReadingMinutes': totalReadingMinutes,
    };
  }
}

class ChapterAnalyticsModel {
  const ChapterAnalyticsModel({
    this.title = '',
    this.views = 0,
    this.engagementRate = 0,
  });

  final String title;
  final int views;
  final double engagementRate;

  factory ChapterAnalyticsModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return ChapterAnalyticsModel(
      title: data['title'] as String? ?? '',
      views: (data['views'] as num?)?.toInt() ?? 0,
      engagementRate: (data['engagementRate'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'views': views,
      'engagementRate': engagementRate,
    };
  }
}

class GrowthAnalyticsModel {
  const GrowthAnalyticsModel({
    this.label = '',
    this.reads = 0,
  });

  final String label;
  final int reads;

  factory GrowthAnalyticsModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? <String, dynamic>{};
    return GrowthAnalyticsModel(
      label: data['label'] as String? ?? '',
      reads: (data['reads'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'reads': reads,
    };
  }
}

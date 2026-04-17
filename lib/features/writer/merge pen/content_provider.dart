import 'package:mythica/features/home/mainicon/Content_Writing_icon/models/content_model.dart' show ContentModel;
import 'package:flutter/material.dart';
import '../services/content_service.dart';

class ContentProvider extends ChangeNotifier {

  final ContentService _service = ContentService();

  List<ContentModel> contents = [];

  bool isLoading = false;

  Future<void> loadContents() async {

    isLoading = true;
    notifyListeners();

    contents = await _service.fetchContents();

    isLoading = false;
    notifyListeners();
  }

  Future<void> publishContent({
    required String title,
    required String content,
    required String category,
  }) async {

    final newContent = ContentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      category: category,
      createdAt: DateTime.now(),
      isDraft: false,
    );

    await _service.publishContent(newContent);

    contents.add(newContent);

    notifyListeners();
  }

  Future<void> saveDraft({
    required String title,
    required String content,
    required String category,
  }) async {

    final draft = ContentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      category: category,
      createdAt: DateTime.now(),
      isDraft: true,
    );

    await _service.saveDraft(draft);

    contents.add(draft);

    notifyListeners();
  }
}
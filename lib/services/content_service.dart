import 'package:mythica/features/home/mainicon/Content_Writing_icon/models/content_model.dart' show ContentModel;


class ContentService {

  final List<ContentModel> _contents = [];

  Future<List<ContentModel>> fetchContents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _contents;
  }

  Future<void> publishContent(ContentModel content) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contents.add(content);
  }

  Future<void> saveDraft(ContentModel content) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contents.add(content);
  }

}
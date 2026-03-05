import 'package:hive/hive.dart';

class OfflineService {
  static const String _boxName = 'webview_cache';
  static const String _cacheKey = 'last_page';

  static Future<void> savePage(String html) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_cacheKey, html);
  }

  static Future<String?> loadPage() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_cacheKey);
  }
}

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class OfflineService {
  static const String _boxName = 'pages';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox<String>(_boxName);
  }

  static Future<void> savePage(String url, String content) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put(url, content);
  }

  static Future<String?> loadPage(String url) async {
    final box = await Hive.openBox<String>(_boxName);
    return box.get(url);
  }
}

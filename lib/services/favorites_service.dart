
import 'package:hive/hive.dart';

class FavoritesService {
  static const String _boxName = 'favorites';

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<void> addFavorite(String songId) async {
    final box = await _openBox();
    await box.put(songId, true);
  }

  Future<void> removeFavorite(String songId) async {
    final box = await _openBox();
    await box.delete(songId);
  }

  Future<bool> isFavorite(String songId) async {
    final box = await _openBox();
    return box.containsKey(songId);
  }

  Future<List<String>> getFavorites() async {
    final box = await _openBox();
    return box.keys.cast<String>().toList();
  }
}

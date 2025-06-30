import '../services/api_service.dart';

class BookmarkService {
  static Future<void> addBookmark(String userId, String spotId) async {
    await ApiService.addBookmark(userId, spotId);
  }

  static Future<void> removeBookmark(String userId, String spotId) async {
    await ApiService.removeBookmark(userId, spotId);
  }

  static Future<List<String>> getUserBookmarks(String userId) async {
    return await ApiService.getUserBookmarks(userId);
  }

  static Future<bool> isBookmarked(String userId, String spotId) async {
    final bookmarks = await getUserBookmarks(userId);
    return bookmarks.contains(spotId);
  }
}
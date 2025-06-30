import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fishing_entry.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = "https://your-api-domain.com/api";
  static String? _authToken;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken');
  }

  static Future<Map<String, String>> _getHeaders() async {
    await init();
    return {
      'Content-Type': 'application/json',
      'Authorization': _authToken != null ? 'Bearer $_authToken' : '',
    };
  }

  static Future<List<FishingEntry>> getEntries() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/entries'),
      headers: await _getHeaders(),
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => FishingEntry.fromJson(json)).toList();
  }

  static Future<String> addEntry(FishingEntry entry, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/entries'));
    request.headers.addAll(await _getHeaders());
    
    request.fields['data'] = json.encode(entry.toJson());
    
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    return json.decode(responseData)['id'];
  }

  static Future<void> toggleLike(String entryId, bool isLiked) async {
    final endpoint = isLiked ? 'like' : 'unlike';
    await http.post(
      Uri.parse('$_baseUrl/entries/$entryId/$endpoint'),
      headers: await _getHeaders(),
    );
  }

  static Future<List<User>> getTopFishers(String fishType) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top/fish/$fishType'),
      headers: await _getHeaders(),
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  }

  // Другие методы...
}
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/fishing_log.dart';
import '../models/location.dart';
import '../models/fish_type.dart';
import '../models/knot.dart';
import '../models/club.dart';
import 'auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final String baseUrl = kDebugMode 
      ? 'http://localhost:8080/api' 
      : 'https://api.fishtrack.app/api';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Request interceptor to add auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthService().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, logout user
          await AuthService().logout();
        }
        handler.next(error);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  // MARK: - User Management
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/user/profile');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/user/profile', data: data);
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _dio.get('/users/search', 
        queryParameters: {'q': query});
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Fishing Logs
  Future<List<FishingLog>> getFishingLogs({
    int page = 1,
    int limit = 20,
    String? userId,
    String? locationId,
  }) async {
    try {
      final response = await _dio.get('/fishing-logs', 
        queryParameters: {
          'page': page,
          'limit': limit,
          if (userId != null) 'user_id': userId,
          if (locationId != null) 'location_id': locationId,
        });
      return (response.data['data'] as List)
          .map((log) => FishingLog.fromJson(log))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<FishingLog> createFishingLog(FishingLog log) async {
    try {
      final response = await _dio.post('/fishing-logs', data: log.toJson());
      return FishingLog.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<FishingLog> updateFishingLog(String id, FishingLog log) async {
    try {
      final response = await _dio.put('/fishing-logs/$id', data: log.toJson());
      return FishingLog.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteFishingLog(String id) async {
    try {
      await _dio.delete('/fishing-logs/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Locations
  Future<List<Location>> getLocations({
    double? lat,
    double? lng,
    double? radius,
    LocationType? type,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get('/locations',
        queryParameters: {
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (radius != null) 'radius': radius,
          if (type != null) 'type': type.name,
          'page': page,
          'limit': limit,
        });
      return (response.data['data'] as List)
          .map((location) => Location.fromJson(location))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Location> createLocation(Location location) async {
    try {
      final response = await _dio.post('/locations', data: location.toJson());
      return Location.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Location> getLocation(String id) async {
    try {
      final response = await _dio.get('/locations/$id');
      return Location.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Fish Types
  Future<List<FishType>> getFishTypes() async {
    try {
      final response = await _dio.get('/fish-types');
      return (response.data as List)
          .map((fish) => FishType.fromJson(fish))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<FishType> getFishType(String id) async {
    try {
      final response = await _dio.get('/fish-types/$id');
      return FishType.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Knots
  Future<List<Knot>> getKnots({String? category}) async {
    try {
      final response = await _dio.get('/knots',
        queryParameters: {
          if (category != null) 'category': category,
        });
      return (response.data as List)
          .map((knot) => Knot.fromJson(knot))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Knot> getKnot(String id) async {
    try {
      final response = await _dio.get('/knots/$id');
      return Knot.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Clubs
  Future<List<Club>> getClubs({
    String? region,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/clubs',
        queryParameters: {
          if (region != null) 'region': region,
          if (query != null) 'q': query,
          'page': page,
          'limit': limit,
        });
      return (response.data['data'] as List)
          .map((club) => Club.fromJson(club))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Club> createClub(Club club) async {
    try {
      final response = await _dio.post('/clubs', data: club.toJson());
      return Club.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Club> getClub(String id) async {
    try {
      final response = await _dio.get('/clubs/$id');
      return Club.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> joinClub(String clubId) async {
    try {
      await _dio.post('/clubs/$clubId/join');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> leaveClub(String clubId) async {
    try {
      await _dio.post('/clubs/$clubId/leave');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - File Upload
  Future<String> uploadFile(File file, {String? folder}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        if (folder != null) 'folder': folder,
      });

      final response = await _dio.post('/upload', data: formData);
      return response.data['url'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> uploadFiles(List<File> files, {String? folder}) async {
    try {
      final formData = FormData.fromMap({
        'files': await Future.wait(
          files.map((file) => MultipartFile.fromFile(file.path))
        ),
        if (folder != null) 'folder': folder,
      });

      final response = await _dio.post('/upload/multiple', data: formData);
      return List<String>.from(response.data['urls']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // MARK: - Ratings & Rankings
  Future<Map<String, dynamic>> getRankings({
    String type = 'catches',
    String period = 'month',
    String? region,
  }) async {
    try {
      final response = await _dio.get('/rankings',
        queryParameters: {
          'type': type,
          'period': period,
          if (region != null) 'region': region,
        });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> likeFishingLog(String logId) async {
    try {
      await _dio.post('/fishing-logs/$logId/like');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> unlikeFishingLog(String logId) async {
    try {
      await _dio.delete('/fishing-logs/$logId/like');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiException(
            'Timeout error. Please check your connection.',
            code: 'TIMEOUT',
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final message = error.response?.data?['message'] ?? 
                          'Unknown server error';
          return ApiException(message, code: statusCode.toString());
        case DioExceptionType.cancel:
          return ApiException('Request was cancelled', code: 'CANCELLED');
        default:
          return ApiException(
            'Network error. Please check your connection.',
            code: 'NETWORK_ERROR',
          );
      }
    }
    return ApiException(error.toString(), code: 'UNKNOWN_ERROR');
  }
}

class ApiException implements Exception {
  final String message;
  final String code;

  ApiException(this.message, {required this.code});

  @override
  String toString() => 'ApiException: $message (code: $code)';
}
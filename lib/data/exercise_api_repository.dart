import 'package:dio/dio.dart';

import 'models/api_exercise.dart';

class ExerciseApiRepository {
  final Dio _dio = Dio();

  static const String _baseUrl = 'https://api.api-ninjas.com/v1/exercises';
  static const String _apiKey = String.fromEnvironment('API_NINJAS_KEY');

  Future<List<ApiExercise>> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception(
          'Missing API key. Run with --dart-define=API_NINJAS_KEY=YOUR_KEY',
        );
      }

      final queryParameters = <String, String>{};

      final normalizedMuscle = muscle?.trim().toLowerCase() ?? '';
      final normalizedType = type?.trim().toLowerCase() ?? '';
      final normalizedDifficulty = difficulty?.trim().toLowerCase() ?? '';
      final normalizedName = name?.trim().toLowerCase() ?? '';

      if (normalizedMuscle.isNotEmpty) {
        queryParameters['muscle'] = normalizedMuscle;
      }
      if (normalizedType.isNotEmpty) {
        queryParameters['type'] = normalizedType;
      }
      if (normalizedDifficulty.isNotEmpty) {
        queryParameters['difficulty'] = normalizedDifficulty;
      }
      if (normalizedName.isNotEmpty) {
        queryParameters['name'] = normalizedName;
      }

      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParameters,
        options: Options(
          headers: {'X-Api-Key': _apiKey},
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      final data = response.data;

      if (data is! List) {
        throw Exception('Malformed response from server.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(ApiExercise.fromJson)
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Check your internet.');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Invalid API key. Check your API Ninjas key.');
      }

      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Wait a moment and try again.');
      }

      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      }

      throw Exception('No internet connection.');
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}

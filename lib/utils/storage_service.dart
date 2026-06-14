import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String quizResultsKey = 'quiz_results';
  static const String projectsKey = 'projects';
  static const String accountsKey = 'accounts';

  // User Data Methods
  static Future<void> saveUserData({
    required String email,
    required String username,
    required String fullName,
    required String school,
    String? profileImageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'email': email,
      'username': username,
      'fullName': fullName,
      'school': school,
      'profileImageUrl': profileImageUrl,
      'savedAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userDataKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    // Merge with existing user data to avoid overwriting important fields like email
    final existing = prefs.getString(userDataKey);
    Map<String, dynamic> merged = {};
    if (existing != null) {
      try {
        merged = jsonDecode(existing) as Map<String, dynamic>;
      } catch (_) {
        merged = {};
      }
    }
    // Overlay provided fields but only when value is not null
    userData.forEach((key, value) {
      if (value != null) {
        merged[key] = value;
      }
    });
    merged['updatedAt'] = DateTime.now().toIso8601String();
    await prefs.setString(userDataKey, jsonEncode(merged));
  }

  // Account management (simple local accounts list)
  static Future<void> saveAccount({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String school,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getStringList(accountsKey) ?? [];
    // Remove any existing account with same email
    all.removeWhere((e) {
      try {
        final m = jsonDecode(e) as Map<String, dynamic>;
        return m['email'] == email;
      } catch (_) {
        return false;
      }
    });
    final account = {
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
      'school': school,
      'createdAt': DateTime.now().toIso8601String(),
    };
    all.add(jsonEncode(account));
    await prefs.setStringList(accountsKey, all);
  }

  static Future<Map<String, dynamic>?> getAccountByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final all = prefs.getStringList(accountsKey) ?? [];
    for (final e in all) {
      try {
        final m = jsonDecode(e) as Map<String, dynamic>;
        if (m['email'] == email) return m;
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  // Login Status Methods
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  // Quiz Results Methods
  static Future<void> saveQuizResult({
    required String materialName,
    required int score,
    required int totalQuestions,
    required double percentage,
    required DateTime completedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allResults = prefs.getStringList(quizResultsKey) ?? [];
    
    final result = {
      'material': materialName,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'completedAt': completedAt.toIso8601String(),
    };
    
    allResults.add(jsonEncode(result));
    await prefs.setStringList(quizResultsKey, allResults);
  }

  static Future<List<Map<String, dynamic>>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final results = prefs.getStringList(quizResultsKey) ?? [];
    return results.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  /// Returns the count of unique quizzes that are considered "passed".
  /// A quiz is considered passed if the best recorded `score` for that
  /// material is greater than or equal to [minCorrect]. Only one pass
  /// per material is counted regardless of how many attempts exist.
  static Future<int> getUniquePassedQuizCount({int minCorrect = 4}) async {
    final all = await getQuizResults();
    final Map<String, int> bestByMaterial = {};
    for (final r in all) {
      try {
        final material = r['material']?.toString() ?? '';
        final score = (r['score'] is int) ? r['score'] as int : int.tryParse(r['score']?.toString() ?? '0') ?? 0;
        if (material.isEmpty) continue;
        if (!bestByMaterial.containsKey(material) || bestByMaterial[material]! < score) {
          bestByMaterial[material] = score;
        }
      } catch (_) {
        continue;
      }
    }
    int count = 0;
    bestByMaterial.forEach((_, bestScore) {
      if (bestScore >= minCorrect) count += 1;
    });
    return count;
  }

  /// Returns a map of materialName -> best result map (highest score recorded for that material).
  /// Each value contains at least: 'score', 'totalQuestions', 'percentage', 'completedAt'.
  static Future<Map<String, Map<String, dynamic>>> getBestScoresByMaterial() async {
    final all = await getQuizResults();
    final Map<String, Map<String, dynamic>> bestByMaterial = {};
    for (final r in all) {
      try {
        final material = r['material']?.toString() ?? '';
        final score = (r['score'] is int) ? r['score'] as int : int.tryParse(r['score']?.toString() ?? '0') ?? 0;
        final totalQuestions = (r['totalQuestions'] is int) ? r['totalQuestions'] as int : int.tryParse(r['totalQuestions']?.toString() ?? '0') ?? 0;
        final percentage = (r['percentage'] is num) ? (r['percentage'] as num).toDouble() : double.tryParse(r['percentage']?.toString() ?? '0') ?? 0.0;
        final completedAt = r['completedAt']?.toString();
        if (material.isEmpty) continue;
        final existing = bestByMaterial[material];
        if (existing == null || (existing['score'] is int ? existing['score'] as int : int.tryParse(existing['score']?.toString() ?? '0') ?? 0) < score) {
          bestByMaterial[material] = {
            'score': score,
            'totalQuestions': totalQuestions,
            'percentage': percentage,
            'completedAt': completedAt,
          };
        }
      } catch (_) {
        continue;
      }
    }
    return bestByMaterial;
  }

  static Future<Map<String, dynamic>?> getQuizResultByMaterial(String materialName) async {
    final allResults = await getQuizResults();
    try {
      return allResults.firstWhere((e) => e['material'] == materialName);
    } catch (e) {
      return null;
    }
  }

  // Project Methods
  static Future<void> saveProjectProgress({
    required String projectId,
    required String projectName,
    required String status, // 'not-started', 'in-progress', 'completed'
    required String? uploadedFilePath,
    required DateTime lastUpdated,
    int estimatedDays = 2,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allProjects = prefs.getStringList(projectsKey) ?? [];
    
    final projectData = {
      'projectId': projectId,
      'projectName': projectName,
      'status': status,
      'uploadedFilePath': uploadedFilePath,
      'lastUpdated': lastUpdated.toIso8601String(),
      'estimatedDays': estimatedDays,
    };
    
    // Remove existing project with same ID
    allProjects.removeWhere((e) {
      final data = jsonDecode(e) as Map<String, dynamic>;
      return data['projectId'] == projectId;
    });
    
    allProjects.add(jsonEncode(projectData));
    await prefs.setStringList(projectsKey, allProjects);
  }

  static Future<List<Map<String, dynamic>>> getProjectProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final projects = prefs.getStringList(projectsKey) ?? [];
    return projects.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<Map<String, dynamic>?> getProjectById(String projectId) async {
    final allProjects = await getProjectProgress();
    try {
      return allProjects.firstWhere((e) => e['projectId'] == projectId);
    } catch (e) {
      return null;
    }
  }

  // Clear All Data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, false);
    // Keep user data but clear session
  }
}

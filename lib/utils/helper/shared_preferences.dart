import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Unique key for the "fresh install" flag
  static const String HAS_SEEN_ONBOARDING_KEY = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(HAS_SEEN_ONBOARDING_KEY) ??
        false; // Use false as default
  }

  Future<void> setHasSeenOnboarding(bool hasSeen) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(HAS_SEEN_ONBOARDING_KEY, hasSeen);
  }

  static const String _uidKey = 'uid';

  // Save UID to SharedPreferences
  static Future<void> saveUid(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  // Retrieve UID from SharedPreferences
  static Future<String?> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }
}

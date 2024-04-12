import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Unique key for the "fresh install" flag
  static const String HAS_SEEN_ONBOARDING_KEY = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(HAS_SEEN_ONBOARDING_KEY) ?? false; // Use false as default
  }

  Future<void> setHasSeenOnboarding(bool hasSeen) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(HAS_SEEN_ONBOARDING_KEY, hasSeen);
  }
  
}
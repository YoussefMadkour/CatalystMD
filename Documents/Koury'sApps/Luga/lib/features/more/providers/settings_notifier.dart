import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  const SettingsState({this.notificationsEnabled = true, this.darkMode = false});
  final bool notificationsEnabled;
  final bool darkMode;
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications() {
    state = SettingsState(notificationsEnabled: !state.notificationsEnabled, darkMode: state.darkMode);
  }

  void toggleDarkMode() {
    state = SettingsState(notificationsEnabled: state.notificationsEnabled, darkMode: !state.darkMode);
  }
}

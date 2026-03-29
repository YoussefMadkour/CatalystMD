Create a Riverpod StateNotifier provider for a Luga feature.

Input: [FeatureName]/[NotifierName]
Example: $ARGUMENTS (e.g. "trips/PostTripNotifier")

Parse to get feature name and notifier name.

Create `lib/features/[feature]/providers/[snake_case]_notifier.dart`

Rules from root CLAUDE.md:
- StateNotifier for mutable state with methods
- FutureProvider.family for parameterised async reads
- StreamProvider for real-time data
- Providers depend on Repository interfaces — never on Supabase directly
- State is always immutable — use copyWith() for updates

Template for StateNotifier:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/[repo]_repository.dart';
import '../../../core/providers/repository_providers.dart';

// ── State class ──────────────────────────────────────────────────────────────

class [NotifierName]State {
  final bool isLoading;
  final String? error;
  // TODO: add state fields

  const [NotifierName]State({
    this.isLoading = false,
    this.error,
    // TODO: add fields with defaults
  });

  [NotifierName]State copyWith({
    bool? isLoading,
    String? error,
    // TODO: all fields as nullable
  }) {
    return [NotifierName]State(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      // TODO: all fields
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class [NotifierName] extends StateNotifier<[NotifierName]State> {
  final [Repo]Repository _repo;

  [NotifierName](this._repo) : super(const [NotifierName]State());

  // TODO: implement methods
  // Each method: set isLoading=true → try → update state → catch → set error

  Future<void> exampleMethod() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: call repository
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final [camelCaseNotifier]Provider =
    StateNotifierProvider<[NotifierName], [NotifierName]State>((ref) {
  return [NotifierName](ref.watch([repo]RepositoryProvider));
});
```

After creating:
1. Show the notifier file
2. Show how to watch it in a screen: `ref.watch([camelCase]Provider)`
3. Show how to call methods: `ref.read([camelCase]Provider.notifier).exampleMethod()`

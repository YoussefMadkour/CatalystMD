Create an abstract repository interface and its Supabase implementation for Luga.

Entity name: $ARGUMENTS
(e.g. "Trip" → TripRepository + SupabaseTripRepository)

Create TWO files:

**File 1: `lib/core/repositories/[snake_case]_repository.dart`**

```dart
import '../models/[snake_case]_model.dart';

/// Abstract repository for [EntityName] data operations.
/// Concrete implementation: SupabaseXRepository in core/data_sources/supabase/
abstract class [Entity]Repository {

  /// Fetch list — add filter params appropriate for this entity
  Future<List<[Entity]Model>> getAll();

  /// Fetch single by ID
  Future<[Entity]Model?> getById(String id);

  /// Create new record
  Future<[Entity]Model> create([Entity]Model model);

  /// Update existing record
  Future<[Entity]Model> update(String id, Map<String, dynamic> updates);

  /// Delete record
  Future<void> delete(String id);

  /// Real-time stream of a single record (for active bookings, live chat etc.)
  Stream<[Entity]Model?> watch(String id);

  // TODO: add entity-specific methods (e.g. for trips: getForCorridor, etc.)
  // Look at features/[feature]/CLAUDE.md for what queries are needed.
}
```

**File 2: `lib/core/data_sources/supabase/supabase_[snake_case]_source.dart`**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/[snake_case]_model.dart';
import '../../repositories/[snake_case]_repository.dart';

class Supabase[Entity]Repository implements [Entity]Repository {
  final SupabaseClient _client;

  Supabase[Entity]Repository(this._client);

  // Table name from docs/schema.md
  static const String _table = '[table_name]';

  @override
  Future<List<[Entity]Model>> getAll() async {
    final data = await _client
        .from(_table)
        .select()
        // TODO: add appropriate filters, ordering
        ;
    return (data as List).map((e) => [Entity]Model.fromJson(e)).toList();
  }

  @override
  Future<[Entity]Model?> getById(String id) async {
    final data = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return [Entity]Model.fromJson(data);
  }

  @override
  Future<[Entity]Model> create([Entity]Model model) async {
    final data = await _client
        .from(_table)
        .insert(model.toJson())
        .select()
        .single();
    return [Entity]Model.fromJson(data);
  }

  @override
  Future<[Entity]Model> update(String id, Map<String, dynamic> updates) async {
    final data = await _client
        .from(_table)
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return [Entity]Model.fromJson(data);
  }

  @override
  Future<void> delete(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  @override
  Stream<[Entity]Model?> watch(String id) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => rows.isEmpty ? null : [Entity]Model.fromJson(rows.first));
  }

  // TODO: implement entity-specific methods
}
```

**File 3: Add provider registration snippet**

Show me this code snippet to add to `lib/core/providers/`:

```dart
// Add to core/providers/repository_providers.dart (or create if doesn't exist)
final [entity]RepositoryProvider = Provider<[Entity]Repository>((ref) {
  return Supabase[Entity]Repository(Supabase.instance.client);
});
```

Show all three outputs. Flag the table name from docs/schema.md and
any entity-specific queries needed based on the feature CLAUDE.md files.

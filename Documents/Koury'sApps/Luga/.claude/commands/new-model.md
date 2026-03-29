Create a new typed Dart model for Luga.

Model name: $ARGUMENTS
(If $ARGUMENTS is e.g. "Trip", create TripModel in snake_case: trip_model.dart)

Create TWO files:

**File 1: `lib/core/models/[snake_case]_model.dart`**

Use this exact structure — no shortcuts, no dynamic types:

```dart
/// [ModelName] — see docs/schema.md for the corresponding DB table.
class [ModelName] {
  final String id;
  // TODO: add all fields based on schema.md — use exact Dart types:
  // uuid → String
  // text → String
  // int → int
  // numeric → double
  // boolean → bool
  // timestamptz → DateTime
  // jsonb → Map<String, dynamic>
  // text[] → List<String>

  const [ModelName]({
    required this.id,
    // TODO: mark required vs optional
  });

  /// Deserialise from Supabase JSON response.
  factory [ModelName].fromJson(Map<String, dynamic> json) {
    return [ModelName](
      id: json['id'] as String,
      // TODO: map every field. Use safe casts.
      // For nullable: json['field'] as String?
      // For DateTime: DateTime.parse(json['created_at'] as String)
      // For enums: [EnumName].values.byName(json['status'] as String)
    );
  }

  /// Serialise for Supabase insert/update.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // TODO: map every field back to JSON
      // Omit id on inserts (DB generates it)
    };
  }

  /// Return a copy with specific fields changed.
  [ModelName] copyWith({
    String? id,
    // TODO: all fields as nullable optional params
  }) {
    return [ModelName](
      id: id ?? this.id,
      // TODO: all fields with ?? fallback
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is [ModelName] &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '[ModelName](id: $id)';
}
```

**File 2: `test/core/models/[snake_case]_model_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:luga/core/models/[snake_case]_model.dart';

void main() {
  group('[ModelName]', () {
    final testJson = {
      'id': 'test-uuid-123',
      // TODO: fill in all required fields
    };

    test('fromJson deserialises correctly', () {
      final model = [ModelName].fromJson(testJson);
      expect(model.id, equals('test-uuid-123'));
      // TODO: assert all fields
    });

    test('toJson serialises correctly', () {
      final model = [ModelName].fromJson(testJson);
      final json = model.toJson();
      expect(json['id'], equals('test-uuid-123'));
      // TODO: assert all fields
    });

    test('copyWith returns updated copy', () {
      final original = [ModelName].fromJson(testJson);
      final copy = original.copyWith(id: 'new-uuid');
      expect(copy.id, equals('new-uuid'));
      expect(original.id, equals('test-uuid-123')); // unchanged
    });

    test('equality works correctly', () {
      final a = [ModelName].fromJson(testJson);
      final b = [ModelName].fromJson(testJson);
      expect(a, equals(b));
    });
  });
}
```

Show me both files. Flag any fields in docs/schema.md for this table
that you're unsure how to type in Dart.

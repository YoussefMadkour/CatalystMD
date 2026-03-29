import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../widgets/review_tag_chips.dart';

class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({super.key, required this.bookingId, required this.toUserId});
  final String bookingId;
  final String toUserId;

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _score = 0;
  final _selectedTags = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate your experience')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => IconButton(
                icon: Icon(i < _score ? Icons.star : Icons.star_border, size: 40),
                onPressed: () => setState(() => _score = i + 1),
              )),
            ),
            const SizedBox(height: AppSpacing.lg),
            ReviewTagChips(
              selectedTags: _selectedTags,
              onToggle: (tag) => setState(() {
                _selectedTags.contains(tag) ? _selectedTags.remove(tag) : _selectedTags.add(tag);
              }),
            ),
            const Spacer(),
            LugaButton(label: 'Submit rating', onPressed: _score > 0 ? () { /* TODO */ } : null),
          ],
        ),
      ),
    );
  }
}

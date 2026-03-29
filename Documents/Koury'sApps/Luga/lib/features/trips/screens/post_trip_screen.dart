import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../providers/post_trip_notifier.dart';
import '../widgets/trip_step_route.dart';
import '../widgets/trip_step_flight.dart';
import '../widgets/trip_step_capacity.dart';
import '../widgets/trip_step_handoff.dart';

class PostTripScreen extends ConsumerStatefulWidget {
  const PostTripScreen({super.key});

  @override
  ConsumerState<PostTripScreen> createState() => _PostTripScreenState();
}

class _PostTripScreenState extends ConsumerState<PostTripScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post trip — Step ${_currentStep + 1} of 4'),
        leading: _currentStep > 0
            ? IconButton(onPressed: _prevStep, icon: const Icon(Icons.arrow_back))
            : null,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TripStepRoute(onNext: _nextStep),
          TripStepFlight(onNext: _nextStep),
          TripStepCapacity(onNext: _nextStep),
          TripStepHandoff(onSubmit: () {
            // TODO: Submit trip
          }),
        ],
      ),
    );
  }
}

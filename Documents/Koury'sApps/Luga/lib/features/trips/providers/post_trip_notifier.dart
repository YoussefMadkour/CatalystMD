import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/trip_model.dart';

final postTripNotifierProvider =
    StateNotifierProvider<PostTripNotifier, PostTripState>((ref) {
  return PostTripNotifier();
});

class PostTripState {
  const PostTripState({
    this.departureCity,
    this.arrivalCity,
    this.departureAirport,
    this.arrivalAirport,
    this.flightNumber,
    this.departureDate,
    this.arrivalDate,
    this.availableWeight,
    this.acceptedCategories = const [],
    this.handoffMethod,
    this.isSubmitting = false,
  });

  final String? departureCity;
  final String? arrivalCity;
  final String? departureAirport;
  final String? arrivalAirport;
  final String? flightNumber;
  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final double? availableWeight;
  final List<String> acceptedCategories;
  final HandoffMethod? handoffMethod;
  final bool isSubmitting;

  PostTripState copyWith({
    String? departureCity,
    String? arrivalCity,
    String? departureAirport,
    String? arrivalAirport,
    String? flightNumber,
    DateTime? departureDate,
    DateTime? arrivalDate,
    double? availableWeight,
    List<String>? acceptedCategories,
    HandoffMethod? handoffMethod,
    bool? isSubmitting,
  }) {
    return PostTripState(
      departureCity: departureCity ?? this.departureCity,
      arrivalCity: arrivalCity ?? this.arrivalCity,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      flightNumber: flightNumber ?? this.flightNumber,
      departureDate: departureDate ?? this.departureDate,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      availableWeight: availableWeight ?? this.availableWeight,
      acceptedCategories: acceptedCategories ?? this.acceptedCategories,
      handoffMethod: handoffMethod ?? this.handoffMethod,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class PostTripNotifier extends StateNotifier<PostTripState> {
  PostTripNotifier() : super(const PostTripState());

  void setRoute({required String departure, required String arrival, String? depAirport, String? arrAirport}) {
    state = state.copyWith(
      departureCity: departure,
      arrivalCity: arrival,
      departureAirport: depAirport,
      arrivalAirport: arrAirport,
    );
  }

  void setFlight({String? flightNumber, DateTime? departure, DateTime? arrival}) {
    state = state.copyWith(
      flightNumber: flightNumber,
      departureDate: departure,
      arrivalDate: arrival,
    );
  }

  void setCapacity({double? weight, List<String>? categories}) {
    state = state.copyWith(
      availableWeight: weight,
      acceptedCategories: categories,
    );
  }

  void setHandoff(HandoffMethod method) {
    state = state.copyWith(handoffMethod: method);
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    // TODO: Create trip via repository, save draft on each step
    state = state.copyWith(isSubmitting: false);
  }
}

/// Flight number verification.
class AviationService {
  AviationService._();

  static Future<FlightInfo?> verifyFlight(String flightNumber, DateTime date) async {
    // TODO: Call aviation API to verify flight
    throw UnimplementedError();
  }
}

class FlightInfo {
  const FlightInfo({
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
  });

  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String status;
}

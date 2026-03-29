/// Supported airports and cities.
abstract final class CorridorConstants {
  static const airports = <String, String>{
    'CAI': 'Cairo International Airport',
    'HBE': 'Borg El Arab Airport',
    'SSH': 'Sharm El Sheikh Airport',
    'HRG': 'Hurghada Airport',
    'JFK': 'John F. Kennedy Airport',
    'LAX': 'Los Angeles Airport',
    'LHR': 'London Heathrow',
    'CDG': 'Paris Charles de Gaulle',
    'DXB': 'Dubai International',
    'RUH': 'King Khalid Airport',
    'JED': 'King Abdulaziz Airport',
    'KWI': 'Kuwait International',
    'DOH': 'Hamad International',
    'IST': 'Istanbul Airport',
    'FRA': 'Frankfurt Airport',
  };

  static const cities = <String, String>{
    'CAI': 'Cairo',
    'HBE': 'Alexandria',
    'SSH': 'Sharm El Sheikh',
    'HRG': 'Hurghada',
    'JFK': 'New York',
    'LAX': 'Los Angeles',
    'LHR': 'London',
    'CDG': 'Paris',
    'DXB': 'Dubai',
    'RUH': 'Riyadh',
    'JED': 'Jeddah',
    'KWI': 'Kuwait City',
    'DOH': 'Doha',
    'IST': 'Istanbul',
    'FRA': 'Frankfurt',
  };

  static List<String> get allAirportCodes => airports.keys.toList();
  static String cityFor(String code) => cities[code] ?? code;
  static String airportFor(String code) => airports[code] ?? code;
}

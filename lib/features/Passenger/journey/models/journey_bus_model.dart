enum BusLayoutType { twoByTwo45, twoByTwo51, unknown }

class BoardingPoint {
  const BoardingPoint(this.location, this.time);
  final String location;
  final String time;
}

class JourneyBusModel {
  const JourneyBusModel({
    required this.from,
    required this.to,
    required this.registrationNumber,
    required this.busName,
    required this.busType,
    required this.frequency,
    required this.departureHour,
    required this.departureMinute,
    required this.durationHours,
    required this.durationMinutes,
    required this.availableSeats,
    required this.totalSeats,
    required this.ticketPrice,
    this.boardingPoints = const [],
  });

  final String from;
  final String to;
  final String registrationNumber;
  final String busName;
  final String busType;
  final String frequency;
  final int departureHour;
  final int departureMinute;
  final int durationHours;
  final int durationMinutes;
  final int availableSeats;
  final int totalSeats;
  final double ticketPrice;
  final List<BoardingPoint> boardingPoints;

  String get routeName => '$from ➔ $to';

  BusLayoutType get layoutType => switch (totalSeats) {
        45 => BusLayoutType.twoByTwo45,
        51 => BusLayoutType.twoByTwo51,
        _ => BusLayoutType.unknown,
      };

  /// Returns arrival as (hour, minute, isNextDay)
  ({int hour, int minute, bool isNextDay}) get arrival {
    final totalDepartureMinutes = departureHour * 60 + departureMinute;
    final totalDurationMinutes = durationHours * 60 + durationMinutes;
    final totalArrivalMinutes = totalDepartureMinutes + totalDurationMinutes;
    return (
      hour: (totalArrivalMinutes ~/ 60) % 24,
      minute: totalArrivalMinutes % 60,
      isNextDay: totalArrivalMinutes >= 1440,
    );
  }

  bool get isMidnightJourney => arrival.isNextDay;

  String _fmt12(int h24, int min) {
    final period = h24 < 12 ? 'AM' : 'PM';
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    return '${h12.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $period';
  }

  String get departureTime => _fmt12(departureHour, departureMinute);
  String get arrivalTime => _fmt12(arrival.hour, arrival.minute);

  String get durationLabel {
    if (durationMinutes == 0) return '${durationHours}h';
    return '${durationHours}h ${durationMinutes}m';
  }
}

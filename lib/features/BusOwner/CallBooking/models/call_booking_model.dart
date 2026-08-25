class CallBookingModel {
  DateTime? travelDate;
  CallBusTripModel? selectedTrip;
  List<int> selectedSeats;
  String passengerName;
  String passengerPhone;
  String passengerNic;

  CallBookingModel({
    this.travelDate,
    this.selectedTrip,
    this.selectedSeats = const [],
    this.passengerName = '',
    this.passengerPhone = '',
    this.passengerNic = '',
  });
}

class CallBusTripModel {
  final String busName;
  final String busNumber;
  final String departureTime;
  final String from;
  final String to;
  final double pricePerSeat;
  final int seatsLeft;

  const CallBusTripModel({
    required this.busName,
    required this.busNumber,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.pricePerSeat,
    required this.seatsLeft,
  });

  String get route => '$from → $to';
}

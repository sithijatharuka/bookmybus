class BookingHistoryModel {
  final String ticketRef;
  final String busName;
  final String busNumber;
  final String route;
  final String from;
  final String to;
  final String passengerName;
  final String passengerPhone;
  final String travelDate;
  final List<String> seats; // e.g. ['33 (Male)', '34 (Female)']
  final String pickup;
  final String drop;
  final String bookedOn; // e.g. '01 Jul 2026 • 8:52 PM'
  final double fare;
  final String status; // 'confirmed', 'cancelled', 'pending'

  const BookingHistoryModel({
    required this.ticketRef,
    required this.busName,
    required this.busNumber,
    required this.route,
    required this.from,
    required this.to,
    required this.passengerName,
    required this.passengerPhone,
    required this.travelDate,
    required this.seats,
    required this.pickup,
    required this.drop,
    required this.bookedOn,
    required this.fare,
    required this.status,
  });
}

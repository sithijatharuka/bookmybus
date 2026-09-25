enum PassengerBookingStatus { pending, confirmed, cancelled }

class PassengerBookingModel {
  final String ticketRef;
  final DateTime travelDate;
  final String from;
  final String to;
  final String busName;
  final String busNumber;
  final String busType;
  final String departureTime;
  final List<int> selectedSeats;
  final Map<int, String> seatGenders;
  final String passengerName;
  final String passengerPhone;
  final String pickupPoint;
  final String dropPoint;
  final PassengerBookingStatus status;
  final DateTime bookedAt;
  final double totalAmount;
  final String paymentStatus;

  const PassengerBookingModel({
    required this.ticketRef,
    required this.travelDate,
    required this.from,
    required this.to,
    required this.busName,
    required this.busNumber,
    required this.busType,
    required this.departureTime,
    required this.selectedSeats,
    required this.seatGenders,
    required this.passengerName,
    required this.passengerPhone,
    required this.pickupPoint,
    required this.dropPoint,
    required this.status,
    required this.bookedAt,
    required this.totalAmount,
    required this.paymentStatus,
  });

  PassengerBookingModel copyWith({PassengerBookingStatus? status, String? paymentStatus}) {
    return PassengerBookingModel(
      ticketRef: ticketRef,
      travelDate: travelDate,
      from: from,
      to: to,
      busName: busName,
      busNumber: busNumber,
      busType: busType,
      departureTime: departureTime,
      selectedSeats: selectedSeats,
      seatGenders: seatGenders,
      passengerName: passengerName,
      passengerPhone: passengerPhone,
      pickupPoint: pickupPoint,
      dropPoint: dropPoint,
      status: status ?? this.status,
      bookedAt: bookedAt,
      totalAmount: totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  String get route => '$from → $to';

  String get seatsLabel => selectedSeats.join(', ');
}

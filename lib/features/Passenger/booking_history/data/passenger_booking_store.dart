import 'package:flutter/foundation.dart';
import '../models/passenger_booking_model.dart';

class PassengerBookingStore extends ChangeNotifier {
  PassengerBookingStore._();
  static final instance = PassengerBookingStore._();

  final List<PassengerBookingModel> _bookings = [];

  List<PassengerBookingModel> get bookings => List.unmodifiable(_bookings);

  void addBooking(PassengerBookingModel booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String ticketRef) {
    final idx = _bookings.indexWhere((b) => b.ticketRef == ticketRef);
    if (idx != -1) {
      _bookings[idx] = _bookings[idx].copyWith(status: PassengerBookingStatus.cancelled);
      notifyListeners();
    }
  }

  static String generateTicketRef() {
    final now = DateTime.now();
    final hex = now.millisecondsSinceEpoch.toRadixString(16).toUpperCase();
    return hex.substring(hex.length - 8);
  }
}

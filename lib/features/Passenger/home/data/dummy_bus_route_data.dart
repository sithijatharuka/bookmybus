import '../models/bus_route_model.dart';

class DummyBusRouteData {
  DummyBusRouteData._();

  static const List<BusRouteModel> routes = [
    // 12:00 AM  →  00:00
    BusRouteModel(
      routeName: 'Mannar ➔ Colombo',
      operatorName: 'AKR EXPRESS',
      busType: 'Luxury',
      frequency: 'Daily',
      departureHour: 0,
      departureMinute: 0,
    ),
    // 06:30 AM  →  06:30
    BusRouteModel(
      routeName: 'Colombo ➔ Kandy',
      operatorName: 'LION EXPRESS',
      busType: 'Super Luxury',
      frequency: 'Daily',
      departureHour: 6,
      departureMinute: 30,
    ),
    // 07:00 AM  →  07:00
    BusRouteModel(
      routeName: 'Galle ➔ Colombo',
      operatorName: 'SOUTHERN LINE',
      busType: 'Luxury',
      frequency: 'Daily',
      departureHour: 7,
      departureMinute: 0,
    ),
    // 08:00 PM  →  20:00
    BusRouteModel(
      routeName: 'Jaffna ➔ Colombo',
      operatorName: 'NORTHERN STAR',
      busType: 'Super Luxury',
      frequency: 'Daily',
      departureHour: 20,
      departureMinute: 0,
    ),
  ];

  static const List<String> cities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Mannar',
    'Jaffna',
    'Trincomalee',
    'Anuradhapura',
    'Kurunegala',
    'Matara',
    'Negombo',
  ];
}

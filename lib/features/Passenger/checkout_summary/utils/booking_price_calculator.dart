const double kPlatformFee = 100.0;
const double kGatewayFeeRate = 0.031;

class BookingPriceCalculator {
  const BookingPriceCalculator({
    required this.ticketPrice,
    required this.seatCount,
  });

  final double ticketPrice;
  final int seatCount;

  double get subtotal => ticketPrice * seatCount;
  double get gatewayFee => (subtotal + kPlatformFee) * kGatewayFeeRate;
  double get total => subtotal + kPlatformFee + gatewayFee;
}

import '../models/cart_item.dart';

class BillingCalculator {
  static const double gstRate = 5.0; // Configurable GST rate

  static double calculateItemTotal(CartItem item) {
    return item.total;
  }

  static double calculateSubtotal(List<CartItem> items) {
    double subtotal = 0;
    for (var item in items) {
      subtotal += calculateItemTotal(item);
    }
    return subtotal;
  }

  static double calculateGST(double subtotal, double rate) {
    return subtotal * rate / 100;
  }

  static double calculateGrandTotal(double subtotal, double gstAmount) {
    return subtotal + gstAmount;
  }
}

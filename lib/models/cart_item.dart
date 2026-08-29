import 'menu_item.dart';
import 'menu_variant.dart';

class CartItem {
  final MenuItem item;
  final MenuVariant variant;
  final int quantity;

  const CartItem({
    required this.item,
    required this.variant,
    this.quantity = 1,
  });

  CartItem copyWith({
    MenuItem? item,
    MenuVariant? variant,
    int? quantity,
  }) {
    return CartItem(
      item: item ?? this.item,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => variant.price * quantity;
}

import 'menu_variant.dart';

class MenuItem {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final bool isVeg;
  final List<MenuVariant> variants;

  const MenuItem({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    this.isVeg = true, // Default to true unless specified
    required this.variants,
  });

  bool get hasVariants => variants.length > 1;

  double get basePrice => variants.isNotEmpty ? variants.first.price : 0.0;
}

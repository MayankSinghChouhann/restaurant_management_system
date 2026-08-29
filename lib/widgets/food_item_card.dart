import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';

class FoodItemCard extends ConsumerWidget {
  final MenuItem item;

  const FoodItemCard({super.key, required this.item});

  void _showVariantSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Variant for ${item.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...item.variants.map((variant) {
                return ListTile(
                  title: Text(variant.name),
                  trailing: Text('₹${variant.price.toStringAsFixed(2)}'),
                  onTap: () {
                    ref.read(cartProvider.notifier).addItem(item, variant);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} (${variant.name}) added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Veg/Non-veg indicator
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                border: Border.all(color: item.isVeg ? Colors.green : Colors.red),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: item.isVeg ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (!item.hasVariants)
                    Text(
                      '₹${item.basePrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  else
                    Text(
                      'from ₹${item.variants.map((v) => v.price).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (item.hasVariants) {
                  _showVariantSelector(context, ref);
                } else {
                  ref.read(cartProvider.notifier).addItem(item, item.variants.first);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('ADD'),
            )
          ],
        ),
      ),
    );
  }
}

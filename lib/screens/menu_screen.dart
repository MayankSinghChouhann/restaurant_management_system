import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/menu_data.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/food_item_card.dart';
import '../widgets/order_summary_bar.dart';
import 'cart_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String _searchQuery = '';
  MenuCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (menuCategories.isNotEmpty) {
      _selectedCategory = menuCategories.first;
    }
  }

  List<MenuItem> get _filteredItems {
    return menuItems.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          item.variants.any((v) => v.name.toLowerCase().contains(_searchQuery.toLowerCase()));
          
      if (_searchQuery.isNotEmpty) {
        return matchesSearch; // Global search if searching
      }
      
      final matchesCategory = _selectedCategory == null || item.categoryId == _selectedCategory!.id;
      return matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Golden Leaf Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food, variants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          
          // Category Selector
          if (_searchQuery.isEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: menuCategories.length,
                itemBuilder: (context, index) {
                  final category = menuCategories[index];
                  final isSelected = category.id == _selectedCategory?.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            
          // Menu Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('No items found'))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return FoodItemCard(item: _filteredItems[index]);
                    },
                  ),
          ),
          
          // Order Summary Bar at bottom if cart is not empty
          if (cartItems.isNotEmpty)
            const OrderSummaryBar(),
        ],
      ),
    );
  }
}

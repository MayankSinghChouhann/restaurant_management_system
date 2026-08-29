import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/menu_data.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/food_item_card.dart';
import '../widgets/order_summary_bar.dart';
import 'cart_screen.dart';
import 'history_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String _searchQuery = '';
  MenuCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (menuCategories.isNotEmpty) {
      _selectedCategory = menuCategories.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredItems {
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      return menuItems.where((item) {
        return item.name.toLowerCase().contains(q) ||
            (item.description?.toLowerCase().contains(q) ?? false) ||
            item.variants.any((v) => v.name.toLowerCase().contains(q)) ||
            menuCategories
                .firstWhere((c) => c.id == item.categoryId,
                    orElse: () => const MenuCategory(id: '', name: ''))
                .name
                .toLowerCase()
                .contains(q);
      }).toList();
    }
    if (_selectedCategory == null) return menuItems;
    return menuItems
        .where((item) => item.categoryId == _selectedCategory!.id)
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartCount =
        cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hotel Golden Leaf',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Restaurant Menu',
                style: TextStyle(fontSize: 11, color: Colors.white60)),
          ],
        ),
        actions: [
          // History
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Order History',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          // Cart with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF2C3E50),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search food, category, variant...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon:
                            const Icon(Icons.close, color: Colors.white54),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Category chips (only when not searching)
          if (_searchQuery.isEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: menuCategories.length,
                  itemBuilder: (context, index) {
                    final cat = menuCategories[index];
                    final isSelected = cat.id == _selectedCategory?.id;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin:
                            const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2C3E50)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2C3E50)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Results count when searching
          if (_searchQuery.isNotEmpty)
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${_filteredItems.length} results for "$_searchQuery"',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

          // Menu items
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No items found',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) =>
                        FoodItemCard(item: _filteredItems[index]),
                  ),
          ),

          // Bottom cart bar
          if (cartItems.isNotEmpty) const OrderSummaryBar(),
        ],
      ),
    );
  }
}

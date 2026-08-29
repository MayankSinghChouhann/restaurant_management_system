import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/menu_variant.dart';

const List<MenuCategory> menuCategories = [
  MenuCategory(id: 'c1', name: 'Breakfast'),
  MenuCategory(id: 'c2', name: 'Beverages'),
  MenuCategory(id: 'c3', name: 'Healthy Salads & Raita'),
  MenuCategory(id: 'c4', name: 'Soups'),
  MenuCategory(id: 'c5', name: 'Chinese Appetizers'),
  MenuCategory(id: 'c6', name: 'Tandoori'),
  MenuCategory(id: 'c7', name: 'Main Course'),
  MenuCategory(id: 'c8', name: 'Rice & Breads'),
  MenuCategory(id: 'c9', name: 'Thali'),
  MenuCategory(id: 'c10', name: 'Round The Clock'),
  MenuCategory(id: 'c11', name: 'Dessert'),
];

final List<MenuItem> menuItems = [
  // BREAKFAST
  MenuItem(
    id: 'm1', categoryId: 'c1', name: 'Continental Breakfast', 
    description: 'Veg Grilled Sandwich and Toast with Jam or Butter, Tea / Hot Coffee',
    variants: [MenuVariant(id: 'm1_v1', name: 'Regular', price: 220)],
  ),
  MenuItem(
    id: 'm2', categoryId: 'c1', name: 'Indian Breakfast', 
    description: 'Choice Of Aaloo / Mix Paratha (Two Pcs) Served With Yoghurt, Pickles, Tea / Coffee',
    variants: [MenuVariant(id: 'm2_v1', name: 'Regular', price: 225)],
  ),
  MenuItem(
    id: 'm3', categoryId: 'c1', name: 'South Indian Breakfast', 
    description: '4 Idli with Sambhar, Chutney and small Uttapam / Chillla',
    variants: [MenuVariant(id: 'm3_v1', name: 'Regular', price: 225)],
  ),
  MenuItem(
    id: 'm4', categoryId: 'c1', name: 'Egg To Order', isVeg: false,
    description: 'Two Pcs Boiled Egg / Omelette, Toast with Butter & Jam, Tea / Hot Coffee',
    variants: [MenuVariant(id: 'm4_v1', name: 'Regular', price: 200)],
  ),
  MenuItem(
    id: 'm5', categoryId: 'c1', name: 'Poori With Aaloo Bhaji', 
    description: 'Four Puri Served with Spiced Potato Sabji',
    variants: [MenuVariant(id: 'm5_v1', name: 'Regular', price: 200)],
  ),
  MenuItem(
    id: 'm6', categoryId: 'c1', name: 'Light Meal', 
    description: 'Cornflakes / Daliya Served with Milk / Coffee',
    variants: [MenuVariant(id: 'm6_v1', name: 'Regular', price: 200)],
  ),
  MenuItem(
    id: 'm7', categoryId: 'c1', name: 'Choley Bature', 
    description: 'Two Deep - Fried Bread Served with Chana Masala',
    variants: [MenuVariant(id: 'm7_v1', name: 'Regular', price: 225)],
  ),
  MenuItem(
    id: 'm8', categoryId: 'c1', name: 'Amrisari Kulcha Choley', 
    description: 'Two Stuffed Kulcha Served with Choley',
    variants: [MenuVariant(id: 'm8_v1', name: 'Regular', price: 225)],
  ),

  // BEVERAGES
  MenuItem(id: 'm9', categoryId: 'c2', name: 'Milk Tea - Tapri', description: 'Regular', variants: [MenuVariant(id: 'm9_v1', name: 'Regular', price: 35)]),
  MenuItem(id: 'm10', categoryId: 'c2', name: 'Milk Tea - Special', variants: [
    MenuVariant(id: 'm10_v1', name: 'Ginger', price: 49),
    MenuVariant(id: 'm10_v2', name: 'Masala', price: 49),
    MenuVariant(id: 'm10_v3', name: 'Elaichi', price: 49),
  ]),
  MenuItem(id: 'm11', categoryId: 'c2', name: 'Black Tea', variants: [
    MenuVariant(id: 'm11_v1', name: 'Darjeeling', price: 49),
    MenuVariant(id: 'm11_v2', name: 'Assam', price: 49),
    MenuVariant(id: 'm11_v3', name: 'Green', price: 49),
  ]),
  MenuItem(id: 'm12', categoryId: 'c2', name: 'Coffee', variants: [
    MenuVariant(id: 'm12_v1', name: 'Black', price: 79),
    MenuVariant(id: 'm12_v2', name: 'Espresso', price: 79),
  ]),
  MenuItem(id: 'm13', categoryId: 'c2', name: 'Cappuccino Coffee', variants: [MenuVariant(id: 'm13_v1', name: 'Regular', price: 99)]),
  MenuItem(id: 'm14', categoryId: 'c2', name: 'Cold Coffee', variants: [MenuVariant(id: 'm14_v1', name: 'Regular', price: 99)]),
  MenuItem(id: 'm15', categoryId: 'c2', name: 'Cold Coffee With Cream', variants: [MenuVariant(id: 'm15_v1', name: 'Regular', price: 159)]),
  MenuItem(id: 'm16', categoryId: 'c2', name: 'Flavoured Cold Coffee', variants: [
    MenuVariant(id: 'm16_v1', name: 'Hazelnut', price: 139),
    MenuVariant(id: 'm16_v2', name: 'Vanilla', price: 139),
    MenuVariant(id: 'm16_v3', name: 'Butterscotch', price: 139),
  ]),
  MenuItem(id: 'm17', categoryId: 'c2', name: 'Hot Chocolate', variants: [MenuVariant(id: 'm17_v1', name: 'Regular', price: 99)]),
  MenuItem(id: 'm18', categoryId: 'c2', name: 'Lassi', variants: [
    MenuVariant(id: 'm18_v1', name: 'Sweet', price: 59),
    MenuVariant(id: 'm18_v2', name: 'Salt', price: 59),
  ]),
  MenuItem(id: 'm19', categoryId: 'c2', name: 'Jaljeera', variants: [MenuVariant(id: 'm19_v1', name: 'Regular', price: 49)]),
  MenuItem(id: 'm20', categoryId: 'c2', name: 'Coke With Ice Cream', variants: [MenuVariant(id: 'm20_v1', name: 'Regular', price: 99)]),
  MenuItem(id: 'm21', categoryId: 'c2', name: 'Fresh Lime', variants: [
    MenuVariant(id: 'm21_v1', name: 'Water', price: 50),
    MenuVariant(id: 'm21_v2', name: 'Soda', price: 60),
  ]),
  MenuItem(id: 'm22', categoryId: 'c2', name: 'Soft Drink', description: 'Bottle / Can', variants: [MenuVariant(id: 'm22_v1', name: 'Regular', price: 50)]), // Used 50 for MRP
  MenuItem(id: 'm23', categoryId: 'c2', name: 'Ice Tea', variants: [
    MenuVariant(id: 'm23_v1', name: 'Peach', price: 99),
    MenuVariant(id: 'm23_v2', name: 'Lemon', price: 99),
    MenuVariant(id: 'm23_v3', name: 'Mint', price: 99),
  ]),

  // HEALTHY SALADS & RAITA
  MenuItem(id: 'm24', categoryId: 'c3', name: 'Onion Salad', variants: [MenuVariant(id: 'm24_v1', name: 'Regular', price: 140)]),
  MenuItem(id: 'm25', categoryId: 'c3', name: 'Garden Fresh Green / Cube Salad', description: 'Onion, Carrot, Cucumber & Tomato', variants: [MenuVariant(id: 'm25_v1', name: 'Regular', price: 160)]),
  MenuItem(id: 'm26', categoryId: 'c3', name: 'Russian Salad', description: 'Wholesome Salad made with Peas, Carrot Potato, Capsicum & Mayonnaise', variants: [MenuVariant(id: 'm26_v1', name: 'Regular', price: 220)]),
  MenuItem(id: 'm27', categoryId: 'c3', name: 'Macaroni Salad', description: 'Served cold made with Cooked Elbow Macroni & Mayonnaise', variants: [MenuVariant(id: 'm27_v1', name: 'Regular', price: 220)]),
  MenuItem(id: 'm28', categoryId: 'c3', name: 'Sprouts Salad (Protein Salad)', variants: [MenuVariant(id: 'm28_v1', name: 'Regular', price: 180)]),
  MenuItem(id: 'm29', categoryId: 'c3', name: 'Raita', variants: [
    MenuVariant(id: 'm29_v1', name: 'Boondi', price: 220),
    MenuVariant(id: 'm29_v2', name: 'Aaloo', price: 220),
    MenuVariant(id: 'm29_v3', name: 'Mix', price: 220),
  ]),
  MenuItem(id: 'm30', categoryId: 'c3', name: 'Fruit Raita', variants: [
    MenuVariant(id: 'm30_v1', name: 'Pineapple', price: 240),
    MenuVariant(id: 'm30_v2', name: 'Mix fruit', price: 240),
  ]),

  // SOUPS
  MenuItem(id: 'm31', categoryId: 'c4', name: 'Cream Of Tomato / Mushroom', description: 'Creamy Smooth Soup with a light Tanginess', variants: [
    MenuVariant(id: 'm31_v1', name: 'Veg', price: 220),
  ]),
  MenuItem(id: 'm32', categoryId: 'c4', name: 'Manchow', description: 'Hot & Spicy', variants: [
    MenuVariant(id: 'm32_v1', name: 'Veg', price: 180),
    MenuVariant(id: 'm32_v2', name: 'Non Veg', price: 220),
  ]),
  MenuItem(id: 'm33', categoryId: 'c4', name: 'Sweet Corn', description: 'Pleasant flavour of corn', variants: [
    MenuVariant(id: 'm33_v1', name: 'Veg', price: 180),
    MenuVariant(id: 'm33_v2', name: 'Non Veg', price: 220),
  ]),
  MenuItem(id: 'm34', categoryId: 'c4', name: 'Hot & Sour', description: 'Spicy & tangy soup', variants: [
    MenuVariant(id: 'm34_v1', name: 'Veg', price: 180),
    MenuVariant(id: 'm34_v2', name: 'Non Veg', price: 220),
  ]),
  MenuItem(id: 'm35', categoryId: 'c4', name: 'Clear Soup', description: 'Prepared by stock water', variants: [
    MenuVariant(id: 'm35_v1', name: 'Veg', price: 180),
    MenuVariant(id: 'm35_v2', name: 'Non Veg', price: 220),
  ]),
  MenuItem(id: 'm36', categoryId: 'c4', name: 'Lemon Coriander', description: 'Clear, tangy and herbaceous soup', variants: [
    MenuVariant(id: 'm36_v1', name: 'Veg', price: 180),
  ]),

  // CHINESE APPETIZERS
  MenuItem(id: 'm37', categoryId: 'c5', name: 'Spring Roll', variants: [
    MenuVariant(id: 'm37_v1', name: 'Veg', price: 200),
    MenuVariant(id: 'm37_v2', name: 'Non Veg', price: 260),
  ]),
  MenuItem(id: 'm38', categoryId: 'c5', name: 'Chilli Paneer / Mushroom', variants: [MenuVariant(id: 'm38_v1', name: 'Regular', price: 320)]),
  MenuItem(id: 'm39', categoryId: 'c5', name: 'Chinese Sizzler', variants: [
    MenuVariant(id: 'm39_v1', name: 'Veg', price: 400),
    MenuVariant(id: 'm39_v2', name: 'Non Veg', price: 480),
  ]),
  MenuItem(id: 'm40', categoryId: 'c5', name: 'Crunchy / Cheese Corn Roll', description: 'Rolls with specially prepared cheese stuffing', variants: [MenuVariant(id: 'm40_v1', name: 'Regular', price: 360)]),
  MenuItem(id: 'm41', categoryId: 'c5', name: 'Crispy Corn / Vegetables', description: 'Batter fried tossed with chinese sauces', variants: [MenuVariant(id: 'm41_v1', name: 'Regular', price: 280)]),
  MenuItem(id: 'm42', categoryId: 'c5', name: 'Special Veg Crubs', description: 'Specially prepared stuffed breads dipped in tangy sauce', variants: [MenuVariant(id: 'm42_v1', name: 'Regular', price: 380)]),
  MenuItem(id: 'm43', categoryId: 'c5', name: 'Noodles', description: 'Hakka / Garlic / Singapore', variants: [
    MenuVariant(id: 'm43_v1', name: 'Veg', price: 220),
    MenuVariant(id: 'm43_v2', name: 'Egg', price: 250),
    MenuVariant(id: 'm43_v3', name: 'Chicken', price: 290),
  ]),
  MenuItem(id: 'm44', categoryId: 'c5', name: 'Manchurian (Dry / Gravy)', variants: [
    MenuVariant(id: 'm44_v1', name: 'Veg', price: 300),
    MenuVariant(id: 'm44_v2', name: 'Chicken', price: 380),
  ]),
  MenuItem(id: 'm45', categoryId: 'c5', name: 'Veg Lollipop', variants: [MenuVariant(id: 'm45_v1', name: 'Regular', price: 300)]),
  MenuItem(id: 'm46', categoryId: 'c5', name: 'Chicken Chilli / Lollipop', description: 'Chicken toasted in sweet spicy and tangy chilli sauce', isVeg: false, variants: [
    MenuVariant(id: 'm46_v1', name: 'Chilli', price: 380),
    MenuVariant(id: 'm46_v2', name: 'Lollipop', price: 420),
  ]),
  MenuItem(id: 'm47', categoryId: 'c5', name: 'Fish Chilli / Fish Fry', isVeg: false, variants: [MenuVariant(id: 'm47_v1', name: 'Regular', price: 440)]),

  // TANDOORI
  MenuItem(id: 'm48', categoryId: 'c6', name: 'Paneer Tikka', variants: [
    MenuVariant(id: 'm48_v1', name: 'Achari', price: 320),
    MenuVariant(id: 'm48_v2', name: 'Malai', price: 320),
  ]),
  MenuItem(id: 'm49', categoryId: 'c6', name: 'Mushroom Tikka', variants: [MenuVariant(id: 'm49_v1', name: 'Regular', price: 300)]),
  MenuItem(id: 'm50', categoryId: 'c6', name: 'Soya Chaap', variants: [
    MenuVariant(id: 'm50_v1', name: 'Afghani', price: 250),
    MenuVariant(id: 'm50_v2', name: 'Achari', price: 250),
  ]),
  MenuItem(id: 'm51', categoryId: 'c6', name: 'Tandoori Gobhi', variants: [MenuVariant(id: 'm51_v1', name: 'Regular', price: 250)]),
  MenuItem(id: 'm52', categoryId: 'c6', name: 'Chicken Tikka', isVeg: false, variants: [
    MenuVariant(id: 'm52_v1', name: '4 Pc', price: 250),
    MenuVariant(id: 'm52_v2', name: '8 Pc', price: 425),
  ]),
  MenuItem(id: 'm53', categoryId: 'c6', name: 'Tandoori Chicken', isVeg: false, variants: [
    MenuVariant(id: 'm53_v1', name: 'Half', price: 250),
    MenuVariant(id: 'm53_v2', name: 'Full', price: 400),
  ]),
  MenuItem(id: 'm54', categoryId: 'c6', name: 'Chicken Malai / Reshmi Tikka', isVeg: false, variants: [
    MenuVariant(id: 'm54_v1', name: '4 Pc', price: 290),
    MenuVariant(id: 'm54_v2', name: '8 Pc', price: 450),
  ]),
  MenuItem(id: 'm55', categoryId: 'c6', name: 'Afghani Chicken', isVeg: false, variants: [
    MenuVariant(id: 'm55_v1', name: 'Half', price: 300),
    MenuVariant(id: 'm55_v2', name: 'Full', price: 490),
  ]),
  MenuItem(id: 'm56', categoryId: 'c6', name: 'Fish Tikka', isVeg: false, variants: [
    MenuVariant(id: 'm56_v1', name: '4 Pc', price: 260),
    MenuVariant(id: 'm56_v2', name: '8 Pc', price: 450),
  ]),

  // MAIN COURSE
  MenuItem(id: 'm57', categoryId: 'c7', name: 'Daal', variants: [
    MenuVariant(id: 'm57_v1', name: 'Tadka', price: 300),
    MenuVariant(id: 'm57_v2', name: 'Panch Ratna', price: 320),
    MenuVariant(id: 'm57_v3', name: 'Dal Makhani', price: 340),
  ]),
  MenuItem(id: 'm58', categoryId: 'c7', name: 'Choley', variants: [
    MenuVariant(id: 'm58_v1', name: 'Curry', price: 320),
    MenuVariant(id: 'm58_v2', name: 'Pindi Chana', price: 320),
    MenuVariant(id: 'm58_v3', name: 'Chana Masala', price: 320),
  ]),
  MenuItem(id: 'm59', categoryId: 'c7', name: 'Mushroom', variants: [
    MenuVariant(id: 'm59_v1', name: 'Matar', price: 360),
    MenuVariant(id: 'm59_v2', name: 'Masala', price: 360),
    MenuVariant(id: 'm59_v3', name: 'Do Payaza', price: 360),
  ]),
  MenuItem(id: 'm60', categoryId: 'c7', name: 'Aaloo', variants: [
    MenuVariant(id: 'm60_v1', name: 'Jeera', price: 280),
    MenuVariant(id: 'm60_v2', name: 'Matar', price: 280),
    MenuVariant(id: 'm60_v3', name: 'Tamatar', price: 280),
  ]),
  MenuItem(id: 'm61', categoryId: 'c7', name: 'Gobhi', variants: [
    MenuVariant(id: 'm61_v1', name: 'Aaloo', price: 300),
    MenuVariant(id: 'm61_v2', name: 'Manchurian', price: 300),
    MenuVariant(id: 'm61_v3', name: 'Masala', price: 300),
    MenuVariant(id: 'm61_v4', name: 'Matar', price: 300),
  ]),
  MenuItem(id: 'm62', categoryId: 'c7', name: 'Kofta', variants: [
    MenuVariant(id: 'm62_v1', name: 'Veg', price: 320),
    MenuVariant(id: 'm62_v2', name: 'Malai', price: 360),
  ]),
  MenuItem(id: 'm63', categoryId: 'c7', name: 'Vegetables', variants: [
    MenuVariant(id: 'm63_v1', name: 'Mix Veg', price: 300),
    MenuVariant(id: 'm63_v2', name: 'Jalfrezi', price: 300),
  ]),
  MenuItem(id: 'm64', categoryId: 'c7', name: 'Paneer', variants: [
    MenuVariant(id: 'm64_v1', name: 'Shahi', price: 390),
    MenuVariant(id: 'm64_v2', name: 'Kadai', price: 390),
    MenuVariant(id: 'm64_v3', name: 'Butter Masala', price: 390),
    MenuVariant(id: 'm64_v4', name: 'Lababdar', price: 390),
    MenuVariant(id: 'm64_v5', name: 'Bhurji', price: 390),
    MenuVariant(id: 'm64_v6', name: 'Cheese Tomato', price: 390),
  ]),
  MenuItem(id: 'm65', categoryId: 'c7', name: 'Dum Aaloo', variants: [
    MenuVariant(id: 'm65_v1', name: 'Kashmiri', price: 340),
    MenuVariant(id: 'm65_v2', name: 'Punjabi', price: 340),
  ]),
  MenuItem(id: 'm66', categoryId: 'c7', name: 'Chaap Butter Masala', variants: [MenuVariant(id: 'm66_v1', name: 'Regular', price: 300)]),
  MenuItem(id: 'm67', categoryId: 'c7', name: 'Navratan Korma', variants: [MenuVariant(id: 'm67_v1', name: 'Regular', price: 380)]),
  MenuItem(id: 'm68', categoryId: 'c7', name: 'Egg Curry', description: 'North Indian style curry with two eggs', isVeg: false, variants: [MenuVariant(id: 'm68_v1', name: 'Regular', price: 330)]),
  MenuItem(id: 'm69', categoryId: 'c7', name: 'Chicken', isVeg: false, variants: [
    MenuVariant(id: 'm69_v1', name: 'Curry (Half)', price: 380),
    MenuVariant(id: 'm69_v2', name: 'Curry (Full)', price: 580),
    MenuVariant(id: 'm69_v3', name: 'Kadai (Half)', price: 380),
    MenuVariant(id: 'm69_v4', name: 'Kadai (Full)', price: 580),
    MenuVariant(id: 'm69_v5', name: 'Masala (Half)', price: 380),
    MenuVariant(id: 'm69_v6', name: 'Masala (Full)', price: 580),
    MenuVariant(id: 'm69_v7', name: 'Butter (Half)', price: 380),
    MenuVariant(id: 'm69_v8', name: 'Butter (Full)', price: 580),
    MenuVariant(id: 'm69_v9', name: 'Rara (Half)', price: 380),
    MenuVariant(id: 'm69_v10', name: 'Rara (Full)', price: 580),
    MenuVariant(id: 'm69_v11', name: 'Kali Mirch (Half)', price: 380),
    MenuVariant(id: 'm69_v12', name: 'Kali Mirch (Full)', price: 580),
  ]),
  MenuItem(id: 'm70', categoryId: 'c7', name: 'Chicken Tikka Masala', isVeg: false, variants: [
    MenuVariant(id: 'm70_v1', name: '4 Pc', price: 380),
    MenuVariant(id: 'm70_v2', name: '8 Pc', price: 580),
  ]),
  MenuItem(id: 'm71', categoryId: 'c7', name: 'Fish', isVeg: false, variants: [
    MenuVariant(id: 'm71_v1', name: 'Curry', price: 600),
    MenuVariant(id: 'm71_v2', name: 'Tikka Masala', price: 600),
  ]),
  MenuItem(id: 'm72', categoryId: 'c7', name: 'Mutton', isVeg: false, variants: [
    MenuVariant(id: 'm72_v1', name: 'Rogan Josh', price: 650),
    MenuVariant(id: 'm72_v2', name: 'Korma', price: 650),
    MenuVariant(id: 'm72_v3', name: 'Rara', price: 650),
    MenuVariant(id: 'm72_v4', name: 'Handi', price: 650),
    MenuVariant(id: 'm72_v5', name: 'Curry', price: 650),
  ]),

  // RICE & BREADS
  MenuItem(id: 'm73', categoryId: 'c8', name: 'Rice', variants: [
    MenuVariant(id: 'm73_v1', name: 'Plain', price: 200),
    MenuVariant(id: 'm73_v2', name: 'Jeera', price: 220),
    MenuVariant(id: 'm73_v3', name: 'Lemon', price: 240),
    MenuVariant(id: 'm73_v4', name: 'Curd Rice', price: 280),
  ]),
  MenuItem(id: 'm74', categoryId: 'c8', name: 'Pulao', variants: [
    MenuVariant(id: 'm74_v1', name: 'Peas', price: 280),
    MenuVariant(id: 'm74_v2', name: 'Veg', price: 280),
    MenuVariant(id: 'm74_v3', name: 'Kashmiri', price: 280),
  ]),
  MenuItem(id: 'm75', categoryId: 'c8', name: 'Biryani With Raita', variants: [
    MenuVariant(id: 'm75_v1', name: 'Veg', price: 400),
    MenuVariant(id: 'm75_v2', name: 'Egg', price: 440),
    MenuVariant(id: 'm75_v3', name: 'Chicken', price: 480),
    MenuVariant(id: 'm75_v4', name: 'Mutton', price: 520),
  ]),
  MenuItem(id: 'm76', categoryId: 'c8', name: 'Fried Rice With Munchurian', variants: [
    MenuVariant(id: 'm76_v1', name: 'Veg', price: 300),
    MenuVariant(id: 'm76_v2', name: 'Egg', price: 320),
    MenuVariant(id: 'm76_v3', name: 'Chicken', price: 360),
  ]),
  MenuItem(id: 'm77', categoryId: 'c8', name: 'Tawa Roti', variants: [
    MenuVariant(id: 'm77_v1', name: 'Plain', price: 30),
    MenuVariant(id: 'm77_v2', name: 'Butter', price: 40),
  ]),
  MenuItem(id: 'm78', categoryId: 'c8', name: 'Naan', variants: [
    MenuVariant(id: 'm78_v1', name: 'Plain', price: 70),
    MenuVariant(id: 'm78_v2', name: 'Butter', price: 80),
  ]),
  MenuItem(id: 'm79', categoryId: 'c8', name: 'Special Naan', variants: [
    MenuVariant(id: 'm79_v1', name: 'Garlic', price: 90),
    MenuVariant(id: 'm79_v2', name: 'Stuffed', price: 100),
    MenuVariant(id: 'm79_v3', name: 'Cheese', price: 120),
  ]),
  MenuItem(id: 'm80', categoryId: 'c8', name: 'Missi Roti', variants: [MenuVariant(id: 'm80_v1', name: 'Regular', price: 50)]),
  MenuItem(id: 'm81', categoryId: 'c8', name: 'Paratha', variants: [
    MenuVariant(id: 'm81_v1', name: 'Laccha', price: 90),
    MenuVariant(id: 'm81_v2', name: 'Pudina', price: 90),
    MenuVariant(id: 'm81_v3', name: 'Mirchi', price: 90),
  ]),
  MenuItem(id: 'm82', categoryId: 'c8', name: 'Sttufed Kulcha', variants: [MenuVariant(id: 'm82_v1', name: 'Regular', price: 90)]),
  MenuItem(id: 'm83', categoryId: 'c8', name: 'Tandoori Paratha (Curd & Pickle)', variants: [
    MenuVariant(id: 'm83_v1', name: 'Aaloo', price: 130),
    MenuVariant(id: 'm83_v2', name: 'Mix', price: 150),
    MenuVariant(id: 'm83_v3', name: 'Paneer', price: 160),
  ]),

  // THALI
  MenuItem(id: 'm84', categoryId: 'c9', name: 'Veg Thali', description: 'Chaach / Soup + Paneer / Sabji + Daal + Raita + Pulao + Roti / Paratha + Sweet', variants: [MenuVariant(id: 'm84_v1', name: 'Regular', price: 350)]),
  MenuItem(id: 'm85', categoryId: 'c9', name: 'Non Veg Thali', isVeg: false, description: 'Chaach / Soup + Chicken + Daal + Raita + Pulao + Roti / Paratha + Sweet', variants: [MenuVariant(id: 'm85_v1', name: 'Regular', price: 410)]),

  // ROUND THE CLOCK
  MenuItem(id: 'm86', categoryId: 'c10', name: 'Veg Maggie', variants: [
    MenuVariant(id: 'm86_v1', name: 'Plain', price: 120),
    MenuVariant(id: 'm86_v2', name: 'Masala', price: 150),
    MenuVariant(id: 'm86_v3', name: 'Cheese', price: 180),
  ]),
  MenuItem(id: 'm87', categoryId: 'c10', name: 'Assorted Pakoda', description: 'Mix vegetables dipped in gram flour', variants: [MenuVariant(id: 'm87_v1', name: 'Regular', price: 240)]),
  MenuItem(id: 'm88', categoryId: 'c10', name: 'Paneer Pakoda', variants: [
    MenuVariant(id: 'm88_v1', name: 'Plain', price: 280),
    MenuVariant(id: 'm88_v2', name: 'Garlic', price: 280), // Wait, image says Plain / Garlic 280/- so price is same
  ]),
  MenuItem(id: 'm89', categoryId: 'c10', name: 'Aaloo Chana Chaat', description: 'Chaat Made From Boiled Potato and White Chickpeas', variants: [MenuVariant(id: 'm89_v1', name: 'Regular', price: 220)]),
  MenuItem(id: 'm90', categoryId: 'c10', name: 'Peanut Chaat', description: 'Peanuts Mingled with Chopped Onion, Tomato & Spices', variants: [MenuVariant(id: 'm90_v1', name: 'Regular', price: 190)]),
  MenuItem(id: 'm91', categoryId: 'c10', name: 'Papad / Masala Papad', variants: [
    MenuVariant(id: 'm91_v1', name: 'Papad', price: 80),
    MenuVariant(id: 'm91_v2', name: 'Masala Papad', price: 120),
  ]),
  MenuItem(id: 'm92', categoryId: 'c10', name: 'Butter Toast', variants: [MenuVariant(id: 'm92_v1', name: 'Regular', price: 150)]),
  MenuItem(id: 'm93', categoryId: 'c10', name: 'Mushroom Duplex', description: 'Mushroom Stuffed with cheese & vegetables', variants: [MenuVariant(id: 'm93_v1', name: 'Regular', price: 380)]),
  MenuItem(id: 'm94', categoryId: 'c10', name: 'Non-Veg Pakora', isVeg: false, variants: [
    MenuVariant(id: 'm94_v1', name: 'Chicken', price: 360),
    MenuVariant(id: 'm94_v2', name: 'Fish', price: 400),
  ]),
  MenuItem(id: 'm95', categoryId: 'c10', name: 'Egg (2 Eggs)', isVeg: false, variants: [
    MenuVariant(id: 'm95_v1', name: 'Boiled', price: 100),
    MenuVariant(id: 'm95_v2', name: 'Scrambled', price: 140),
    MenuVariant(id: 'm95_v3', name: 'Bhurji', price: 160),
  ]),
  MenuItem(id: 'm96', categoryId: 'c10', name: 'Omelette With Toast', isVeg: false, variants: [
    MenuVariant(id: 'm96_v1', name: 'Plain', price: 140),
    MenuVariant(id: 'm96_v2', name: 'Masala', price: 160),
    MenuVariant(id: 'm96_v3', name: 'Cheese', price: 180),
  ]),
  MenuItem(id: 'm97', categoryId: 'c10', name: 'Corn Chaat', description: 'Chaat made from sweet corn & veggies', variants: [MenuVariant(id: 'm97_v1', name: 'Regular', price: 200)]),
  MenuItem(id: 'm98', categoryId: 'c10', name: 'Cheese Ball / Cheese Chill Toast', variants: [MenuVariant(id: 'm98_v1', name: 'Regular', price: 320)]),
  MenuItem(id: 'm99', categoryId: 'c10', name: 'French Fries', variants: [
    MenuVariant(id: 'm99_v1', name: 'Salted', price: 149),
    MenuVariant(id: 'm99_v2', name: 'Peri Peri', price: 169),
    MenuVariant(id: 'm99_v3', name: 'Cheesy', price: 199),
    MenuVariant(id: 'm99_v4', name: 'Honey Chilli', price: 249),
  ]),
  MenuItem(id: 'm100', categoryId: 'c10', name: 'Pan Fried Paneer', description: 'Arabian (6 Pc) / Cheese Kabana (10 Pc) / Black Pepper / Chilli Garlic(6 Pc)', variants: [MenuVariant(id: 'm100_v1', name: 'Regular', price: 280)]),
  MenuItem(id: 'm101', categoryId: 'c10', name: 'Momos (6 Pc)', variants: [
    MenuVariant(id: 'm101_v1', name: 'Steam', price: 120),
    MenuVariant(id: 'm101_v2', name: 'Pan Fry', price: 150),
  ]),
  MenuItem(id: 'm102', categoryId: 'c10', name: 'Pasta - Veg', variants: [
    MenuVariant(id: 'm102_v1', name: 'Red Sauce', price: 249),
    MenuVariant(id: 'm102_v2', name: 'White Sauce', price: 249),
    MenuVariant(id: 'm102_v3', name: 'Pink Sauce', price: 249),
  ]),
  MenuItem(id: 'm103', categoryId: 'c10', name: 'Sandwich - Veg', variants: [
    MenuVariant(id: 'm103_v1', name: 'Plain', price: 129),
    MenuVariant(id: 'm103_v2', name: 'Grilled', price: 169),
    MenuVariant(id: 'm103_v3', name: 'Cheese Corn Tomato', price: 199),
    MenuVariant(id: 'm103_v4', name: 'Cheese Spinach', price: 199),
  ]),
  MenuItem(id: 'm104', categoryId: 'c10', name: 'Chicken Grilled Sandwich', isVeg: false, variants: [
    MenuVariant(id: 'm104_v1', name: 'Tandoori', price: 259),
    MenuVariant(id: 'm104_v2', name: 'Smoked', price: 269),
  ]),

  // DESSERT
  MenuItem(id: 'm105', categoryId: 'c11', name: 'Ice Creams', variants: [
    MenuVariant(id: 'm105_v1', name: 'Vanilla', price: 99),
    MenuVariant(id: 'm105_v2', name: 'Strawberry', price: 99), // Assume same base for some unless specified, wait the image says 99 / 120, let's say premium are 120
    MenuVariant(id: 'm105_v3', name: 'Butterscotch', price: 99),
    MenuVariant(id: 'm105_v4', name: 'Chocolate', price: 120),
    MenuVariant(id: 'm105_v5', name: 'American Nuts', price: 120),
  ]),
  MenuItem(id: 'm106', categoryId: 'c11', name: 'Gulab Jamun (2 Pc)', variants: [
    MenuVariant(id: 'm106_v1', name: 'Without Ice Cream', price: 90),
    MenuVariant(id: 'm106_v2', name: 'With Ice Cream', price: 140),
  ]),
  MenuItem(id: 'm107', categoryId: 'c11', name: 'Rasgullas / Ras Malai', variants: [
    MenuVariant(id: 'm107_v1', name: 'Rasgullas', price: 180),
    MenuVariant(id: 'm107_v2', name: 'Ras Malai', price: 200),
  ]),
  MenuItem(id: 'm108', categoryId: 'c11', name: 'Moong Dal Halwa (Seasonal)', variants: [MenuVariant(id: 'm108_v1', name: 'Regular', price: 140)]),
  MenuItem(id: 'm109', categoryId: 'c11', name: 'Gajar Halwa (Seasonal)', variants: [MenuVariant(id: 'm109_v1', name: 'Regular', price: 200)]),
  MenuItem(id: 'm110', categoryId: 'c11', name: 'Tutti - Frutti Sundae', variants: [MenuVariant(id: 'm110_v1', name: 'Regular', price: 220)]),
];

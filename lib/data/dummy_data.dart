import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'models/product.dart';

class DummyData {
  DummyData._();

  // =========================
  // CATEGORY MENU
  // =========================

  static const categories = [
    CategoryItem('Promo', Icons.local_offer, Color(0xFF3D8BFD), 
    image: 'assets/images/promo.jpg'),
    CategoryItem('Pizza', Icons.local_pizza, Color(0xFFD9534F), 
    image: 'assets/images/pizza.jpg'),
    CategoryItem('Sides', Icons.ramen_dining, Color(0xFFF0A04B), 
    image: 'assets/images/sides.jpg'),
    CategoryItem('Bread', Icons.bakery_dining, Color(0xFF8D5A3B), 
    image: 'assets/images/bread.jpg'),
    CategoryItem('Wings', Icons.set_meal, Color(0xFFC0602B), 
    image: 'assets/images/wings.jpg'),
    CategoryItem('Dessert', Icons.icecream, Color(0xFFB07A55), 
    image: 'assets/images/dessert.jpg'),
    CategoryItem('Drinks', Icons.local_drink, Color(0xFFE23B3B), 
    image: 'assets/images/drinks.jpg'),
    CategoryItem('See All', Icons.apps, Color(0xFFE8A26B), 
    image: 'assets/images/cat_pizza.jpg'),
  ];

  // =========================
  // HOME SCREEN
  // =========================

  static const todaysSpecial = [
    Product(
      name: '11.11 Sale!',
      description: 'Titan Volcano Meatmax',
      price: 11000,
      imageColor: Color(0xFF3FA9F5),
      imageIcon: Icons.sell,
    ),
    Product(
      name: 'Papi Mabar',
      description: 'Papi Mabar',
      price: 120909,
      originalPrice: 193273,
      imageColor: Color(0xFF1E6FB8),
    ),
  ];

  static const paketHemat = [
    Product(
      name: 'Papi Uno',
      description: 'Papi Uno',
      price: 50909,
      originalPrice: 80000,
      imageColor: Color(0xFF2A7DE1),
    ),
    Product(
      name: 'My Paket',
      description: '1 Pizza Mania + 1 Tasty Pocket',
      price: 27727,
      originalPrice: 40454,
      imageColor: Color(0xFFB0B0B0),
    ),
    Product(
      name: 'Papi Duo',
      description: '1 Personal + 1 Sides',
      price: 50000,
      originalPrice: 80000,
      imageColor: Color(0xFF2A7DE1),
    ),
  ];

  static const paketParty = [
    Product(
      name: 'Papi Lima',
      description: 'Papi Lima',
      price: 227273,
      originalPrice: 270000,
      imageColor: Color(0xFF1E8FE8),
    ),
    Product(
      name: 'Papi Trio',
      description: '3 Medium HT/TC/PAN',
      price: 161364,
      originalPrice: 300000,
      imageColor: Color(0xFF0E8CE8),
    ),
  ];

  static const paketPizza = [
    Product(
      name: 'Papi Duo Cheeseburst',
      description: '2 Medium CB Viral/Premium/Classic Pizza',
      price: 140000,
      originalPrice: 218184,
      imageColor: Color(0xFF2A8BE8),
    ),
  ];

  // =========================
  // SUB TABS
  // =========================

  static const subTabs = <String, List<String>>{
    'Pizza': [
      'Sultan Pizza',
      'Viral',
      'Premium',
      'Classic',
    ],

    'Sides': [
      'Sides',
      'Pasta',
    ],

    'Bread': [
      'Bread',
      'Rice',
    ],

    'Wings': [
      'Wings',
      'Dipping Sauce',
    ],

    'Dessert': [
      'Dessert',
    ],

    'Drinks': [
      'Drinks',
    ],
  };

  // =========================
  // PROMO
  // =========================

  static const menuProducts = <String, List<Product>>{
    'Promo': [
      Product(
        name: 'Papi Duo App',
        description:'Medium Viral/ Premium /Classic Pizza (Hand-Tossed / THIN / PAN) worth to Rp.50rb / Pizza. Valid for delivery and takeaway. *Price excludes tax',
        price: 100000,
        originalPrice: 200000,
        imageColor: Color(0xFF2D6FB5),
        image: 'assets/images/papi_duo_app.jpg',
        promoItems: [
          PromoItem('Beef Pepperoni Feast',
              image: 'assets/images/classic1.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
          PromoItem('Cheesy Sausage',
              image: 'assets/images/classic2.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
        ],
      ),
      Product(
        name: 'Papi Nobar Sultan',
        description:'Papi Nobar Sultan',
        price: 128818,
        originalPrice: 168727,
        imageColor: Color(0xFF2D6FB5),
        image: 'assets/images/papi_nobar_sultan.jpg',
        promoItems: [
          PromoItem('XL Cheese Volcano Meatmax',
              image: 'assets/images/sultan1.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
          PromoItem('Cheesy Bread',
              image: 'assets/images/bread1.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
        ],
      ),
      Product(
        name: 'Papi Mabar',
        description:'Papi Mabar',
        price: 120909,
        originalPrice: 193273,
        imageColor: Color(0xFF2D6FB5),
        image: 'assets/images/papi_mabar.jpg',
        promoItems: [
          PromoItem('XL Chicken Mushroom Truffle',
              image: 'assets/images/sultan3.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
          PromoItem('Mac\'N Truflle Alfredo Beef Extra Cheese',
              image: 'assets/images/pasta3.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
        ],
      ),
      Product(
        name: 'Papi Lima',
        description: 'Papi Lima',
        price: 227273,
        originalPrice: 270000,
        imageColor: Color(0xFF1E8FE8),
        image: 'assets/images/papi_nobar_sultan.jpg',
        promoItems: [
          PromoItem('Extravaganzza',
              image: 'assets/images/premium3.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
          PromoItem('Ultimate Meatzza Overload',
              image: 'assets/images/premium1.jpg',
              size: 'Medium',
              sizeIcon: Icons.local_pizza,
              crust: 'Classic Handtossed'),
        ],
      ),
    ],
  };

// =========================
  // TOPPING
  // =========================
  static const _toppingsVolcano = [
          Topping('Rustic Sauce', image: 'assets/images/toping.jpg'),
          Topping('Mayonnaise', image: 'assets/images/toping.jpg'),
          Topping('Mozarella Cheese', image: 'assets/images/toping.jpg'),
          Topping('Chicken Sausage', image: 'assets/images/toping.jpg'),
          Topping('Sausage Cut', image: 'assets/images/toping.jpg'),
          Topping('Beef Crumble', image: 'assets/images/toping.jpg'),
          Topping('Pizza Sauce', image: 'assets/images/toping.jpg'),
          Topping('Mustard Sauce', free: false, image: 'assets/images/toping.jpg'),
          Topping('Slice Cheese', free: false, image: 'assets/images/toping.jpg'),
          Topping('Green Pepper', free: false, image: 'assets/images/toping.jpg'),
          Topping('Mushroom', free: false, image: 'assets/images/toping.jpg'),
          Topping('Onion', free: false, image: 'assets/images/toping.jpg'),
          Topping('Corn', free: false, image: 'assets/images/toping.jpg'),
           ];
     
  // =========================
  // PRODUCT BY SUB CATEGORY
  // =========================

  static const productsBySubCategory = <String, List<Product>>{

    // PIZZA

    'Sultan Pizza': [
      Product(
        name: 'XL Cheese Vocano Meatmax',
        description:'Vocano Meatmax Sultan 1KG Beratnya!',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/sultan1.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'XL Beef Mushroom Truffle',
        description:
            'Truffle Alfredo, Mozzarella Cheese, Beef Burger, Onion, Champignon Mushroom, Parmesan Cheese & Parhsley',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/sultan2.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'XL Chicken Mushroom Truffle',
        description:'Truffle Alfredo Sauce, Mozzarella Cheese, Chk Sausage, Onion, Champignon Mushroom, Parmesan Cheese & Parshley',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/sultan3.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
    ],

    'Viral': [
      Product(
        name: 'New! Ppicy K-Lava Volcano',
        description:'New! Spicy K-Lava Volcano',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral1.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Pio Cheesy Abon',
        description:'Abon Sapi, Bombai, Sauce Keju, Cheddar, Mayonnaise, Paprika, Bbeef Rasher, Keju Mozzarella',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral2.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Baru! Pie Cheesy Durian',
        description:'100% Daging Durian, Sauce Keju Cheddar, Sauce Keju Creamy, Keju Mozzarella',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral3.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
    ],

    'Premium': [
      Product(
        name: 'Ultimate Meatzza Overload',
        description:'Ultimate Meatzza Overload',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium1.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Classic cheeseburger',
        description:'Tomato Sauce, Mustard Sauce, Tomato, Union, Beef Crumble, Beef Rasher, Sliced Chees & Mozzarella Cheese',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium2.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Extravaganzza',
        description:'Domino\'s Pizza Sauce, Green Pepper, Beef Crumble, Beef Pepperoni, Mushroom, Onion, Black Olives & Mozzarella Cheese',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium3.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
    ],

    'Classic': [
      Product(
        name: 'Beef Pepperoni Feast',
        description:'Classic Mozzarella Pizza',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic1.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Cheesey Sausage',
        description:'Domino\'s Pizza Sauce, Beef Sausage & Mozzarella Cheese',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic2.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
      Product(
        name: 'Beef Delight',
        description:'Domino\'s Pizza Sauce, Beef Rasher & Mozzarella Cheese',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic3.jpg',
        sizes: [ProductSize('Large', icon: Icons.local_pizza)],
        crust: 'Overload',
        toppings: _toppingsVolcano,
        maxToppings: 11,
        toppingPrice: 8182,
      ),
    ],

    // SIDES

    'Sides': [
      Product(
        name: 'Tasty Creamy Beef Sausage',
        description:'Tasty Creamy Beef Sausage',
        price: 10000,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.restaurant,
        image: 'assets/images/sides1.jpg'
      ),
      Product(
        name: 'Tasty Stuffed Pocked Spicy Chicken Sausage',
        description:'Tasty Stuffed Pocked Spicy Chicken Sausage',
        price: 10000,
        crust: 'PCCS',
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.restaurant,
        image: 'assets/images/sides2.jpg'
      ),
      Product(
        name: 'Crispy Tortilla Chips',
        description:'Crispy Tortilla Chips',
        price: 18182,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.restaurant,
        image: 'assets/images/sides3.jpg'
      ),
    ],

    'Pasta': [
      Product(
        name: 'Spicy K-Lava Volcano Spaghetti',
        description:'Spicy K-Lava Volcano Spaghetti',
        price: 31818,
        crust: 'SLS',
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.ramen_dining,
        image: 'assets/images/pasta1.jpg'
      ),
      Product(
        name: 'Mac\'N Cheese',
        description:'Mac\'N Cheese',
        price: 31818,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.ramen_dining,
        image: 'assets/images/pasta2.jpg'
      ),
      Product(
        name: 'Mac\'N Truffle Alfredo Beef Extra Cheese',
        description:'Mac\'N Truffle Alfredo Beef Extra Cheese',
        price: 36364,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.ramen_dining,
        image: 'assets/images/pasta3.jpg'
      ),
    ],

    // BREAD

    'Bread': [
      Product(
        name: 'Cheesy Bread',
        description: 'Cheesy Bread',
        price: 29091,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('8 Pieces')],
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/bread1.jpg'
      ),
      Product(
        name: 'Garlic Cheesy Rolls',
        description: 'Garlic Cheesy Rolls',
        price: 21818,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('2 Pieces')],
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/bread2.jpg'
      ),
      Product(
        name: 'Cheesy Calzone Sticks',
        description: 'Cheesy Calzone Sticks',
        price: 32727,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('8 Pieces')],
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/bread3.jpg'
      ),
    ],

    'Rice': [
      Product(
        name: 'Sambal-Crispy Chicken Strips Rice',
        description: 'Sambal-Crispy Chicken Strips Rice',
        price: 17273,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/rice1.jpg'
      ),
      Product(
        name: 'BBQ-Crispy Chicken Strips Rice',
        description: 'BBQ-Crispy Chicken Strips Rice',
        price: 30909,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/rice2.jpg'
      ),
      Product(
        name: 'Crispy Chicken Strips Rice',
        description: 'Garlic Bread dengan keju',
        price: 30909,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.bakery_dining,
        image: 'assets/images/rice3.jpg'
      ),
    ],

    // WINGS

    'Wings': [
      Product(
        name: '5 Pieces Spicy K-Lava Chicken Wings',
        description: 'Spicy K-Lava Chicken Wings',
        price: 30000,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('5 Pieces')],
        crust: 'CKCL',
        imageIcon: Icons.set_meal,
        image: 'assets/images/wings1.jpg'
      ),
      Product(
        name: '10 Pieces Spicy K-Lava Chicken Wings',
        description: '10 Pieces Spicy K-Lava Chicken Wings',
        price: 30000,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('10 Pieces')],
        crust: 'CKCL',
        imageIcon: Icons.set_meal,
        image: 'assets/images/wings2.jpg'
      ),
      Product(
        name: 'Chicken Wings (10 pcs)',
        description: 'Chicken Wings (10 pcs)',
        price: 30000,
        imageColor: Color(0xFFB9BEC6),
        sizes: [ProductSize('10 Pieces')],
        crust: 'Chicken Wings',
        imageIcon: Icons.set_meal,
        image: 'assets/images/wings3.jpg'
      ),
    ],

    'Dipping Sauce': [
      Product(
        name: 'Chessy Dipping Sauce',
        description: 'Chessy Sauce',
        price: 3636,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.set_meal,
        image: 'assets/images/sauce1.jpg'
      ),
      Product(
        name: 'Rustic Dipping Sauce',
        description: 'Rustic Sauce',
        price: 3636,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.set_meal,
        image: 'assets/images/sauce2.jpg'
      ),
      Product(
        name: 'Mayonnaise Dipping Sauce',
        description: 'Mayonnaise Sauce',
        price: 3636,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.set_meal,
        image: 'assets/images/sauce3.jpg'
      ),
      Product(
        name: 'Tomato Dipping Sauce',
        description: 'Tomato Sauce',
        price: 3636,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.set_meal,
        image: 'assets/images/sauce4.jpg'
      ),
    ],

    // DESSERT

    'Dessert': [
      Product(
        name: 'Chococic Rolls',
        description: 'Chococic Rolls',
        price: 27273,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.icecream,
        image: 'assets/images/Dessert1.jpg'
      ),
      Product(
        name: 'Choco Bread Sticks',
        description: 'Choco Bread Sticks',
        price: 25455,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.icecream,
        image: 'assets/images/Dessert2.jpg'
      ),
      Product(
        name: 'Chocolate Lava',
        description: 'Choco Lava',
        price: 27273,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.icecream,
        image: 'assets/images/Dessert3.jpg'
      ),
    ],

    // DRINKS

    'Drinks': [
      Product(
        name: 'Fanta',
        description: 'Fanta',
        price: 13812,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.local_drink,
        image: 'assets/images/Drinks1.jpg',
        sizes: [
          ProductSize('1 Liter', price: 21818, icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
        ],
        defaultSize: 1, 
        crust: 'Fanta',
      ),
      Product(
        name: 'Coca Cola',
        description: 'Coca Cala',
        price: 18727,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.local_drink,
        image: 'assets/images/Drinks2.jpg',
        sizes: [
          ProductSize('1 Liter', price: 21818, icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
        ],
        defaultSize: 1, 
        crust: 'Coca Cola',
      ),
      Product(
        name: 'Sprite',
        description: 'Sprite',
        price: 13182,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.local_drink,
        image: 'assets/images/Drinks3.jpg',
        sizes: [
          ProductSize('1 Liter', price: 21818, icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
        ],
        defaultSize: 1, 
        crust: 'Sprite',
      ),
      Product(
        name: 'Frestea Apple',
        description: 'Frestea Apple',
        price: 12727,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.local_drink,
        image: 'assets/images/Drinks4.jpg',
        sizes: [
          ProductSize('350 ml', icon: Icons.local_drink,
              iconColor: Color(0xFFD32F2F)),
        ],
        defaultSize: 1, 
        crust: 'Frestea Apple',
      ),
    ],
  };
}
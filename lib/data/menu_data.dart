
import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'models/product.dart';

class MenuData {
  MenuData._();

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
  // SUB TAB PER KATEGORI
  // =========================
  // Kunci   = label kategori (harus sama dengan CategoryItem di atas).
  // Isinya  = nama sub tab, dan SETIAP nama harus ada sebagai kunci di
  //           productsBySubCategory (kalau beda satu huruf, halamannya kosong).
  // Kategori yang tidak ada di sini (mis. Promo) memakai menuProducts.
  // Kategori yang sub tab-nya cuma satu tidak menampilkan baris sub tab.
  static const subTabs = <String, List<String>>{
    'Pizza': ['Sultan Pizza', 'Viral', 'Premium', 'Classic'],
    'Sides': ['Sides', 'Pasta'],
    'Bread': ['Bread', 'Rice'],
    'Wings': ['Wings', 'Dipping Sauce'],
    'Dessert': ['Dessert'],
    'Drinks': ['Drinks'],
  };

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
      imageUrl: 'https://static.dominos.co.id/contents/images/1794539458_PAPI_MABAR__13-15_NOV__Full_Size_Product_Banner_-_1595x640.webp',
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
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e31e3653-e4de-4705-96f1-0fcfc82d6519_227653_2a4a01af_Papi_Mini.png?auto=format',
    ),
    Product(
      name: 'Papi Duo',
      description: '1 Personal + 1 Sides',
      price: 50000,
      originalPrice: 80000,
      imageColor: Color(0xFF2A7DE1),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/06d6bad3-37b2-47b8-ad23-4fffa4a997e6_Banner-PAPI-DUO.jpg',
    ),
  ];

  static const paketParty = [
    Product(
      name: 'Papi Lima',
      description: 'Papi Lima',
      price: 227273,
      originalPrice: 270000,
      imageColor: Color(0xFF1E8FE8),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/77d346e8-5bcb-433c-bf37-6139df85b85e_723868_19cff3a8_Papi_Lima_BOLA.png?auto=format',
    ),
    Product(
      name: 'Papi Trio',
      description: '3 Medium HT/TC/PAN',
      price: 161364,
      originalPrice: 300000,
      imageColor: Color(0xFF0E8CE8),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e1a9c2ce-206b-4779-b412-36aa0d7e5ce7_240949_bbefeff0_Papi_Trio.png?auto=format',
    ),
    Product(
      name: 'Papi Large',
      description: '2 Large Pizza',
      price: 150000,
      originalPrice: 250000,
      imageColor: Color(0xFF1E8FE8),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/35f469fc-8772-4f20-b172-7fff98607d80_240950_e0b2af52_Papi_Duo_Large.png?auto=format',
    ),
  ];

  static const paketPizza = [
    Product(
      name: 'Papi Duo Cheeseburst',
      description: '2 Medium CB Viral/Premium/Classic Pizza Rp 140.000 (Harga belum termasuk pajak)',
      price: 140000,
      originalPrice: 218184,
      imageColor: Color(0xFF2A8BE8),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/4046cbcb-e038-41d7-b1a4-8f51705a01e5_227651_5f034606_Papi_Duo_Cheeseburst.png?auto=format',
    ),
    Product(
      name: 'Papi Duo Double Cheeseburst',
      description: '2 Medium Double CB Viral/Premium/Classic Pizza Rp 148.182 (Harga belum termasuk pajak)',
      price: 148182,
      originalPrice: 227274,
      imageColor: Color(0xFF2A8BE8),
      imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/5d0cb6af-9c55-40dc-bb8b-2000535b3068_231671_e0254b63_Papi_Duo_Double_Cheeseburst.png?auto=format',
    ),
  ];

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
              sizeImage: 'assets/images/medium.png',
              crust: 'Classic Handtossed'),
          PromoItem('Cheesy Sausage',
              image: 'assets/images/classic2.jpg',
              size: 'Medium',
              sizeImage: 'assets/images/medium.png',
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
              sizeImage: 'assets/images/medium.png',
              crust: 'Classic Handtossed'),
          PromoItem('Cheesy Bread',
              image: 'assets/images/bread1.jpg',
              size: '8 Pieces',
              sizeImage: 'assets/images/bag.jpeg',
              crust: 'Cheesy Bread'),
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
              sizeImage: 'assets/images/medium.png',
              crust: 'Classic Handtossed'),
          PromoItem('Extravaganza',
              image: 'assets/images/premium3.jpg',
              size: 'Medium',
              sizeImage: 'assets/images/medium.png',
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
              sizeImage: 'assets/images/medium.png',
              crust: 'Classic Handtossed'),
          PromoItem('Ultimate Meatzza Overload',
              image: 'assets/images/premium1.jpg',
              size: 'Medium',
              sizeImage: 'assets/images/medium.png',
              crust: 'Classic Handtossed'),
        ],
      ),
    ],
  };

  // =========================
  // TOPPING
  // =========================
    static const _crustsMedium = [
      CrustOption('Classic Handtossed'),
      CrustOption('Filled Chili Mozzarella', price: 13636),
      CrustOption('Cheese Burst', price: 13636),
      CrustOption('Crunchy Thin Crust', price: 4545),
      CrustOption('Soft PAN Pizza', price: 4545),
      CrustOption('Double Cheese Burst', price: 18182),
    ];

  static const _toppingsPremium = [
          Topping('Rustic Sauce', image: 'assets/images/rustic sauce.png'),
          Topping('Mayonnaise', image: 'assets/images/mayo.png'),
          Topping('Mozarella Cheese', image: 'assets/images/mozarella.png'),
          Topping('Chicken Sausage', image: 'assets/images/chicken.png'),
          Topping('Sausage Cut', image: 'assets/images/sausage cut.png'),
          Topping('Beef Crumble', image: 'assets/images/beef crumble.png'),
          Topping('Pizza Sauce', image: 'assets/images/pizza sauce.png'),
          Topping('Mustard Sauce', free: false, image: 'assets/images/mustard sauce.png'),
          Topping('Slice Cheese', free: false, image: 'assets/images/slice cheese.png'),
          Topping('Green Pepper', free: false, image: 'assets/images/green pepper.png'),
          Topping('Mushroom', free: false, image: 'assets/images/mushroom.png'),
          Topping('Onion', free: false, image: 'assets/images/onion.png'),
          Topping('Truffle Mushroom Sauce', free: false, image: 'assets/images/truffle.png'),
          Topping('Corn', free: false, image: 'assets/images/corn.png'),
          Topping('Chicken Pepperoni', free: false, image: 'assets/images/chicken pepperoni.png'),
          Topping('Tomato', free: false, image: 'assets/images/tomato.png'),
          Topping('Beef Pepperoni', free: false, image: 'assets/images/beef.png'),
          Topping('Beef Rasher', free: false, image: 'assets/images/beef rasher.png'),
           ];
  static const _toppingsVolcano = [
          Topping('Rustic Sauce', image: 'assets/images/rustic sauce.png'),
          Topping('Mayonnaise', image: 'assets/images/mayo.png'),
          Topping('Mozarella Cheese', image: 'assets/images/mozarella.png'),
          Topping('Chicken Sausage', image: 'assets/images/chicken.png'),
          Topping('Sausage Cut', image: 'assets/images/sausage cut.png'),
          Topping('Beef Crumble', image: 'assets/images/beef crumble.png'),
          Topping('Pizza Sauce', image: 'assets/images/pizza sauce.png'),
          Topping('Mustard Sauce', free: false, image: 'assets/images/mustard sauce.png'),
          Topping('Slice Cheese', free: false, image: 'assets/images/slice cheese.png'),
          Topping('Green Pepper', free: false, image: 'assets/images/green pepper.png'),
          Topping('Mushroom', free: false, image: 'assets/images/mushroom.png'),
          Topping('Onion', free: false, image: 'assets/images/onion.png'),
          Topping('Truffle Mushroom Sauce', free: false, image: 'assets/images/truffle.png'),
          Topping('Corn', free: false, image: 'assets/images/corn.png'),
          Topping('Chicken Pepperoni', free: false, image: 'assets/images/chicken pepperoni.png'),
          Topping('Tomato', free: false, image: 'assets/images/tomato.png'),
          Topping('Beef Pepperoni', free: false, image: 'assets/images/beef.png'),
          Topping('Beef Rasher', free: false, image: 'assets/images/beef rasher.png'),
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
        sizes: [
          ProductSize('Large',
              price: 150000, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Overload')]), 
        ],
        defaultSize: 0, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'XL Beef Mushroom Truffle',
        description:
            'Truffle Alfredo, Mozzarella Cheese, Beef Burger, Onion, Champignon Mushroom, Parmesan Cheese & Parhsley',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/sultan2.jpg',
        sizes: [
          ProductSize('Large',
              price: 150000, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Overload')]), 
        ],
        defaultSize: 0, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'XL Chicken Mushroom Truffle',
        description:'Truffle Alfredo Sauce, Mozzarella Cheese, Chk Sausage, Onion, Champignon Mushroom, Parmesan Cheese & Parshley',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/sultan3.jpg',
        sizes: [
          ProductSize('Large',
              price: 150000, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Overload')]), 
        ],
        defaultSize: 0, 
        toppings: _toppingsPremium,
      ),
    ],

    'Viral': [
      Product(
        name: 'New! Ppicy K-Lava Volcano',
        description:'New! Spicy K-Lava Volcano',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral1.jpg',
        sizes: [
          ProductSize('Large',
              price: 129090, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]), 
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: [CrustOption('Classic Handtossed')]),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'Pio Cheesy Abon',
        description:'Abon Sapi, Bombai, Sauce Keju, Cheddar, Mayonnaise, Paprika, Bbeef Rasher, Keju Mozzarella',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral2.jpg',
        sizes: [
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 0, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'Baru! Pie Cheesy Durian',
        description:'100% Daging Durian, Sauce Keju Cheddar, Sauce Keju Creamy, Keju Mozzarella',
        price: 90909,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/viral3.jpg',
        sizes: [
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
    ],

    'Premium': [
      Product(
        name: 'Ultimate Meatzza Overload',
        description:'Ultimate Meatzza Overload',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium1.jpg',
        sizes: [
          ProductSize('Personal',
              price: 43181,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 107727, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]), 
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'Classic cheeseburger',
        description:'Tomato Sauce, Mustard Sauce, Tomato, Union, Beef Crumble, Beef Rasher, Sliced Chees & Mozzarella Cheese',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium2.jpg',
        sizes: [
          ProductSize('Personal',
              price: 43181,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 107727, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]), 
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsVolcano,
      ),
      Product(
        name: 'Extravaganzza',
        description:'Domino\'s Pizza Sauce, Green Pepper, Beef Crumble, Beef Pepperoni, Mushroom, Onion, Black Olives & Mozzarella Cheese',
        price: 75000,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/premium3.jpg',
        sizes: [
          ProductSize('Personal',
              price: 43181,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 107727, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]), 
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
    ],

    'Classic': [
      Product(
        name: 'Beef Pepperoni Feast',
        description:'Classic Mozzarella Pizza',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic1.jpg',
        sizes: [
          ProductSize('Personal',
              price: 25000,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 85454, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'Cheesey Sausage',
        description:'Domino\'s Pizza Sauce, Beef Sausage & Mozzarella Cheese',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic2.jpg',
        sizes: [
          ProductSize('Personal',
              price: 25000,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 85454, 
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
      ),
      Product(
        name: 'Beef Delight',
        description:'Domino\'s Pizza Sauce, Beef Rasher & Mozzarella Cheese',
        price: 46818,
        imageColor: Color(0xFFB9BEC6),
        image: 'assets/images/classic3.jpg',
        sizes: [
          ProductSize('Personal',
              price: 25000,
              image: 'assets/images/personal.png',
              hasToppings: false,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Large',
              price: 85454,
              image: 'assets/images/large.png',
              toppingPrice: 8182,
              crusts: [CrustOption('Classic Handtossed')]),
          ProductSize('Medium',
              image: 'assets/images/medium.png', 
              toppingPrice: 6364,
              crusts: _crustsMedium),
        ],
        defaultSize: 2, 
        toppings: _toppingsPremium,
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
          ProductSize('1 Liter', price: 21818, image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
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
          ProductSize('1 Liter', price: 21818, image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
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
          ProductSize('1 Liter', price: 21818, image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
          ProductSize('390 ml', image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
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
          ProductSize('350 ml', image: 'assets/images/size.png',
              icon: Icons.local_drink, iconColor: Color(0xFFD32F2F)),
        ],
        defaultSize: 1, 
        crust: 'Frestea Apple',
      ),
    ],
  };
}
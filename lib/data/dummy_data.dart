
import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'models/product.dart';

class DummyData {
  DummyData._();

  static const categories = [
    CategoryItem('Promo', Icons.local_offer, Color(0xFF3D8BFD)),
    CategoryItem('Pizza', Icons.local_pizza, Color(0xFFD9534F)),
    CategoryItem('Sides', Icons.ramen_dining, Color(0xFFF0A04B)),
    CategoryItem('Bread', Icons.bakery_dining, Color(0xFF8D5A3B)),
    CategoryItem('Wings', Icons.set_meal, Color(0xFFC0602B)),
    CategoryItem('Dessert', Icons.icecream, Color(0xFFB07A55)),
    CategoryItem('Drinks', Icons.local_drink, Color(0xFFE23B3B)),
    CategoryItem('See All', Icons.apps, Color(0xFFE8A26B)),
  ];

  static const todaysSpecial = [
    Product(
      name: '11.11 Sale!',
      description: 'Titan (Volcano Meatmax/...',
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
      description: '3 Medium HT/TC/PAN..',
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
        description: 'Medium Viral/ Premium /Classic Pizza (Hand-Tossed / THIN...',
        price: 100000,
        originalPrice: 200000,
        imageColor: Color(0xFF2D6FB5),
        imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/06d6bad3-37b2-47b8-ad23-4fffa4a997e6_Banner-PAPI-DUO.jpg',
      ),
      Product(
        name: 'Papi Lima',
        description: 'Papi Lima',
        price: 227273,
        originalPrice: 270000,
        imageColor: Color(0xFF1E8FE8),
        imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/77d346e8-5bcb-433c-bf37-6139df85b85e_723868_19cff3a8_Papi_Lima_BOLA.png?auto=format',
      ),
    ],
    'Pizza': [
      Product(
        name: 'XL Cheese Volcano Meatmax',
        description: 'Vocano Meatmax Sultan 1 KG Beratnya!',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
      ),
      Product(
        name: 'XL Beef Mushroom Truffle',
        description: 'Truffle Alfredo Sauce, Mozzarella Cheese, Beef Burger, On...',
        price: 150000,
        imageColor: Color(0xFFB9BEC6),
      ),
    ],
    'Sides': [
      Product(
        name: 'Tasty Stuffed Pocket Spicy Chicken Sausage',
        description: 'Tasty Stuffed Pocket Spicy Chicken Sausage',
        price: 10000,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.bakery_dining,
      ),
      Product(
        name: 'Tasty Stuffed Pocket Peppery Beef Sausage With Cheese',
        description: 'Tasty Stuffed Pocket Peppery Beef Sausage With Cheese',
        price: 10000,
        imageColor: Color(0xFFB9BEC6),
        imageIcon: Icons.bakery_dining,
      ),
    ],
  };

  static const subTabs = <String, List<String>>{
    'Pizza': ['Sultan Pizza', 'Viral', 'Premium', 'Classic'],
    'Sides': ['Sides', 'Pasta'],
  };
}

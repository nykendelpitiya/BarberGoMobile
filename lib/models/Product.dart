import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/barb10.png",
      "assets/images/barb10.png",
      "assets/images/barb10.png",
      "assets/images/barb10.png",
    ],
    colors: [
   
    ],
    title: "001",
    price: 600.00,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/barb13.png",
    ],
    colors: [
     
    ],
    title: "002",
    price: 1200.00,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/barb9.png",
    ],
    colors: [
     
    ],
    title: "003",
    price: 1800.00,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/barb12.png",
    ],
    colors: [
    
    ],
    title: "004",
    price: 1000.00,
    description: description,
    rating: 4.2,
    isFavourite: true,
  ),
  Product(
    id: 1,
    images: [
      "assets/images/barb11.png",
      "assets/images/barb11.png",
      "assets/images/barb11.png",
      "assets/images/barb11.png",
    ],
    colors: [
     
    ],
    title: "005",
    price: 1500.00,
    description: description,
    rating: 4.5,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "assets/images/barb8.png",
    ],
    colors: [
    
    ],
    title: "006",
    price: 2500.00,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "assets/images/barb13.png",
    ],
    colors: [
    
    ],
    title: "007",
    price: 3500.00,
    description: description,
    rating: 4.9,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "assets/images/barb10.png",
    ],
    colors: [
    
    ],
    title: "008",
    price: 4200.00,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description =
    "Discover brand-new, high-quality toys perfect for every age! Affordable prices, endless fun, and smiles guaranteed. Shop now and enjoy! …";
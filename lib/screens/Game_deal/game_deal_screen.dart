import 'package:flutter/material.dart';

class GameDealScreen extends StatelessWidget {
  static const String routeName = '/game_deal';

  final List<Map<String, dynamic>> flashDeals = [
    {
      "name": "Wireless Gaming Mouse",
      "price": 2500,
      "originalPrice": 3000,
      "discount": 17,
      "image": "assets/images/game1.png",
      "delivery": "FREE DELIVERY",
      "stock": "In stock",
    },
    {
      "name": "Mechanical Gaming Keyboard",
      "price": 4500,
      "originalPrice": 5000,
      "discount": 10,
      "image": "assets/images/game2.png",
      "delivery": "FREE DELIVERY",
      "stock": "Only 2 left!",
    },
    {
      "name": "Gaming Headset",
      "price": 3500,
      "originalPrice": 4000,
      "discount": 12,
      "image": "assets/images/game3.png",
      "delivery": "FREE DELIVERY",
      "stock": "On sale now",
    },
    {
      "name": "Gaming Chair",
      "price": 12000,
      "originalPrice": 15000,
      "discount": 20,
      "image": "assets/images/game4.png",
      "delivery": "FREE DELIVERY",
      "stock": "Only 1 left!",
    },
    {
      "name": "Gaming Ps4",
      "price": 18000,
      "originalPrice": 20000,
      "discount": 10,
      "image": "assets/images/ps4_console_blue_1.png",
      "delivery": "FREE DELIVERY",
      "stock": "In stock",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Deals"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: flashDeals.length,
        itemBuilder: (context, index) {
          final deal = flashDeals[index];
          return Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    deal["image"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal["name"],
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "Rs. ${deal["price"]}",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rs. ${deal["originalPrice"]}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "${deal["discount"]}% off",
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        deal["delivery"],
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        deal["stock"],
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

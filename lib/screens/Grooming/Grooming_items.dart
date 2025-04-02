import 'package:flutter/material.dart';

class GroomingItemsPage extends StatelessWidget {
  static const String routeName = '/grooming-items';
  
  final List<Map<String, dynamic>> groomingItems = [
    {
      'name': 'Shampoo',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5vjLjcgU0de7AJZDq36LvTI7I_bAr2LBm-Q&s',
    },
    {
      'name': 'Conditioner',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZNeoyeLbHbT8XaRxjPHW3mx43BOutyI7Jnw&s',
    },
    {
      'name': 'Hair Gel',
      'image': 'https://www.nbc.lk/storage/uploads/image/5_6618e0b00ecb0.png/medium/5_6618e0b00ecb0.png',
    },
    {
      'name': 'Face Wash',
      'image': 'https://cloudinary.images-iherb.com/image/upload/f_auto,q_auto:eco/images/him/him50047/l/13.jpg',
    },
    {
      'name': 'Moisturizer',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX6uJidvJ0zc2EXYomljGBbJIdYsPAEG2mag&s',
    },
    {
      'name': 'Razor',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaRY9-PE94Pch55HBHwdiRvnXN-1nnySXkIA&s',
    },
    {
      'name': 'Shaving Cream',
      'image': 'https://myravana.lk/cdn/shop/products/QmXqdANWoe.jpg?v=1610346747',
    },
    {
      'name': 'Deodorant',
      'image': 'https://janet.lk/cdn/shop/files/Pink-Petals_Pefumed-Deo_30ml.png?v=1682619950',
    },
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beauty & Grooming Items'),
        backgroundColor: const Color(0xFFFFB22C),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFFFB22C).withOpacity(0.1),
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: groomingItems.length,
          itemBuilder: (context, index) {
            return GroomingItemCard(
              itemName: groomingItems[index]['name']!,
              imageUrl: groomingItems[index]['image']!,
            );
          },
        ),
      ),
    );
  }
}

class GroomingItemCard extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  
  const GroomingItemCard({
    Key? key,
    required this.itemName,
    required this.imageUrl,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: const Color(0xFFFFB22C),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB22C),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
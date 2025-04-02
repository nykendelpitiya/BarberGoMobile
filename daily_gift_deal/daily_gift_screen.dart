import 'package:flutter/material.dart';

class SalonDailyOffersScreen extends StatefulWidget {
  static const String routeName = '/salon-daily-offers';

  const SalonDailyOffersScreen({Key? key}) : super(key: key);

  @override
  _SalonDailyOffersScreenState createState() => _SalonDailyOffersScreenState();
}

class _SalonDailyOffersScreenState extends State<SalonDailyOffersScreen> {
  final List<Map<String, dynamic>> _dailyOffers = [
    {
      'id': 1,
      'name': 'Men\'s Haircut',
      'description': 'Premium haircut with styling for men',
      'image': 'assets/images/barb10.png',
      'originalPrice': 30.0,
      'discountedPrice': 15.0,
      'remainingSlots': 5,
      'claimed': false,
      'timeSlots': ['10:00 AM', '2:00 PM', '4:30 PM'],
    },
    {
      'id': 2,
      'name': 'Men\'s Haircut',
      'description': 'Professional haircut with blow dry',
      'image': 'assets/images/barb9.png',
      'originalPrice': 45.0,
      'discountedPrice': 25.0,
      'remainingSlots': 3,
      'claimed': false,
      'timeSlots': ['11:00 AM', '3:00 PM', '5:30 PM'],
    },
    {
      'id': 3,
      'name': 'Kids Haircut',
      'description': 'Fun and gentle haircut for children',
      'image': 'assets/images/barb13.png',
      'originalPrice': 25.0,
      'discountedPrice': 12.0,
      'remainingSlots': 7,
      'claimed': false,
      'timeSlots': ['9:00 AM', '1:00 PM', '3:30 PM'],
    },
  ];

  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 245),
      appBar: AppBar(
        title: const Text('Today\'s Haircut Offers'),
        backgroundColor: const Color(0xFFFFB22C),
      ),
      body: _dailyOffers.isEmpty
          ? const Center(
              child: Text('No special offers available today.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _dailyOffers.length,
              itemBuilder: (context, index) {
                final offer = _dailyOffers[index];
                return SalonOfferCard(
                  offer: offer,
                  onClaim: () => _claimOffer(index),
                );
              },
            ),
    );
  }

  void _claimOffer(int index) {
    final offer = _dailyOffers[index];
    if (offer['remainingSlots'] > 0 && !offer['claimed']) {
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Book ${offer['name']}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Original Price: \$${offer['originalPrice']}'),
                  Text(
                    'Today\'s Price: \$${offer['discountedPrice']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  const Text('Available Time Slots:'),
                  const SizedBox(height: 8),
                  ...offer['timeSlots'].map<Widget>((slot) => RadioListTile(
                        title: Text(slot),
                        value: slot,
                        groupValue: _selectedTimeSlot,
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeSlot = value as String?;
                          });
                        },
                      )),
                  if (_selectedTimeSlot == null)
                    const Text(
                      'Please select a time slot',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: _selectedTimeSlot == null
                      ? null
                      : () {
                          setState(() {
                            _dailyOffers[index]['remainingSlots']--;
                            _dailyOffers[index]['claimed'] = true;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${offer['name']} booked at $_selectedTimeSlot!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _selectedTimeSlot = null;
                        },
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: Color(0xFFFFB22C)),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else if (offer['claimed']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already booked this offer today.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No more slots available for this offer today.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class SalonOfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final VoidCallback onClaim;

  const SalonOfferCard({
    Key? key,
    required this.offer,
    required this.onClaim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(
                    child: Image.asset(
                      offer['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.cut,
                        size: 64,
                        color: Color(0xFFFFB22C),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red, // Changed from purple to red
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${offer['remainingSlots']} slots left',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  offer['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '\$${offer['originalPrice']}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '\$${offer['discountedPrice']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // Changed from purple to red
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(100 - (offer['discountedPrice'] / offer['originalPrice'] * 100)).round()}% OFF',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: offer['remainingSlots'] > 0 && !offer['claimed']
                        ? onClaim
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: offer['claimed']
                          ? Colors.grey
                          : const Color(0xFFFFB22C), // Orange color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      offer['claimed']
                          ? 'Booked'
                          : offer['remainingSlots'] > 0
                              ? 'Book Now'
                              : 'Fully Booked',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors
                            .white, // Added white text for better contrast
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:barbergo/screens/booking/booking_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barbergo/screens/booking/booking.dart';
// import 'package:barbergo/screens/Game_deal/game_deal_screen.dart';
import 'package:barbergo/screens/daily_gift_deal/daily_gift_screen.dart';
import 'package:barbergo/screens/Grooming/Grooming_items.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Booking"},
      {"icon": "assets/icons/Game Icon.svg", "text": "History"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Daily Offers"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "Grooming Item"},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              if (categories[index]["text"] == "Booking") {
                Navigator.pushNamed(context, SalonBookingScreen.routeName);
              } else if (categories[index]["text"] == "History") {
                  Navigator.pushNamed(context, BookingHistoryScreen.routeName);
              } else if (categories[index]["text"] == "Daily Offers") {
                Navigator.pushNamed(context, SalonDailyOffersScreen.routeName);
              } else if (categories[index]["text"] == "Grooming Item") {
                Navigator.pushNamed(context, GroomingItemsPage.routeName);
              }
              // Feed and Activity buttons won't navigate anywhere now
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}

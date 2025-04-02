import 'dart:async';
import 'package:flutter/material.dart';

class ImageSliderBanner extends StatefulWidget {
  const ImageSliderBanner({Key? key}) : super(key: key);

  @override
  _ImageSliderBannerState createState() => _ImageSliderBannerState();
}

class _ImageSliderBannerState extends State<ImageSliderBanner> {
  final List<String> bannerImages = [
    'assets/images/banner3.jpg',
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner1.jpg',
  ];

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % bannerImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(bannerImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    return List.generate(
      bannerImages.length,
      (index) => Container(
        width: 10,
        height: 15, // Adjust the size
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index
              ? Theme.of(context).primaryColor
              : Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
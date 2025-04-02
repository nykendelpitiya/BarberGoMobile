import 'package:flutter/material.dart';
import '../../../models/Product.dart';

class ColorDots extends StatefulWidget {
  const ColorDots({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ColorDots> createState() => _ColorDotsState();
}

class _ColorDotsState extends State<ColorDots> {
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ...List.generate(
            widget.product.colors.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 2),
                padding: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: selectedColor == index
                      ? const Color(0xFFFFECDF)
                      : Colors.transparent,
                  border: Border.all(
                    color: selectedColor == index
                        ? const Color(0xFFFF7643)
                        : Colors.transparent,
                  ),
                  shape: BoxShape.circle,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.product.colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

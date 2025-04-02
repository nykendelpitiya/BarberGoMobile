import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barbergo/providers/cart_provider.dart';
import 'package:barbergo/screens/cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) => IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              numOfitem: cartProvider.itemCount,
              press: () => Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
        ],
      ),
    );
  }
}

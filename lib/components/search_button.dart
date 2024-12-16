import 'package:babysitterapp/pages/search_page/search_page.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/route_animation.dart';
import 'package:flutter/material.dart';

class AppSearchButton extends StatelessWidget {
  const AppSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Inside color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(color: primaryColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {
        Navigator.of(context).push(
          RouteAnimate(0.0, -1.0, page: const SearchPage()),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Search', style: TextStyle(fontSize: 16, color: primaryColor)),
          Icon(
            Icons.search,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}

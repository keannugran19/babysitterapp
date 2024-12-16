import 'package:flutter/material.dart';

class RouteAnimate<T> extends PageRouteBuilder<T> {
  final Widget page;
  final double x;
  final double y;

  RouteAnimate(this.x, this.y, {required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(x, y);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

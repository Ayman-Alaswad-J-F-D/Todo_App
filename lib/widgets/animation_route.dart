import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeTrasitionScreen extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  FadeTrasitionScreen.splash({
    required this.page,
    this.duration = const Duration(seconds: 1),
  }) : super(
          pageBuilder: (context, animation, animationTow) => page,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, animationTow, child) =>
              FadeTransition(opacity: animation, child: child),
        );

  FadeTrasitionScreen.between({
    required this.page,
    this.duration = const Duration(milliseconds: 800),
    // this.route,
  }) : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
              reverseCurve: Curves.easeInOut,
            );
            return SlideTransition(
              textDirection: TextDirection.ltr,
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              // alignment: Alignment.centerLeft,
              child: page,
            );
          },
        );
}

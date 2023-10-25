import 'package:flutter/material.dart';
import 'package:todo_app/widgets/animation_route.dart';

extension NavigatorPush on BuildContext {
  backScreen() => Navigator.of(this).pop();

  toScreen({required Widget screen}) {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // * Navigation Push With Fade Animation Trasition
  toScreenReplAnimation({required Widget screen}) {
    return Navigator.pushReplacement(
      this,
      FadeTrasitionScreen.splash(page: screen),
    );
  }

  toScreenAnimation({required Widget screen}) {
    return Navigator.push(
      this,
      FadeTrasitionScreen.between(page: screen),
    );
  }

////                                                      /

  // * Navigation Push Named
  // toScreenNamed({required String screen}) => Navigator.pushNamed(this, screen);

  // toScreenReplacNamed({required String screen}) =>
  //     Navigator.pushReplacementNamed(this, screen);
}

// extension NonNullString on String? {
//   String orEmpty() {
//     if (this == null) {
//       return Constants.empty;
//     } else {
//       return this!;
//     }
//   }
// }

// extension NonNullInteger on int? {
//   int orZero() {
//     if (this == null) {
//       return Constants.zero;
//     } else {
//       return this!;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Image splashIcon;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    splashIcon = Image.asset(
      Constants.splashIcon,
      filterQuality: FilterQuality.low,
    );

    Future.delayed(
      const Duration(milliseconds: 1800),
      () => context.toScreenReplAnimation(screen: const HomeScreen()),
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(splashIcon.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                height: 130.h,
                child: splashIcon,
              ),
            ),
            const Flexible(
              child: LabelWidget(
                title: 'Todo Day',
                fontSize: 20,
                color: AppColors.primary,
                pT: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

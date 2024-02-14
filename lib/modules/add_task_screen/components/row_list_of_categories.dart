import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/styles/colors.dart';

class RowListOfCategories extends StatelessWidget {
  const RowListOfCategories({
    Key? key,
    required this.cubit,
    required this.isEmptyImage,
  }) : super(key: key);

  final TodoAppCubit cubit;
  final bool isEmptyImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        Constants.listSvgIcons.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => cubit.selectCategoryIcon(index),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: CircleAvatar(
                  radius: 21.5.r,
                  backgroundColor: cubit.selected == index && isEmptyImage
                      ? AppColors.primary
                      : AppColors.white,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.secandry,
                    child: SvgPicture.asset(
                      Constants.listSvgIcons[index],
                      // width: widthScreen(context) / 8.2,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

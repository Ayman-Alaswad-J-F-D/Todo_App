import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/cubit/cubit.dart';
import '../../../shared/styles/colors.dart';

class CircleImageSeleceted extends StatelessWidget {
  const CircleImageSeleceted({
    Key? key,
    required this.isEmptyImage,
    required this.cubit,
  }) : super(key: key);

  final bool isEmptyImage;
  final TodoAppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: !isEmptyImage ? 40.w : 0,
          child: !isEmptyImage
              ? CircleAvatar(
                  radius: 21.5.r,
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundImage: FileImage(
                      cubit.imageFromGallery,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        IconButton(
          iconSize: 28.r,
          color: AppColors.primary,
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () => cubit.pickImage(),
        ),
      ],
    );
  }
}

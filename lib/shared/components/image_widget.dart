import 'package:flutter/material.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';
import 'constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.model}) : super(key: key);

  final Map model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          radius: 37.0,
          child: model['image'] != '' ? null : Text('${model['time']}'),
          backgroundImage:
              model['image'] != '' ? AssetImage(model['image']) : null,
        ),
        CircleAvatar(
          radius: 10,
          backgroundColor: AppColors.deebOrangeS300,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.edit_sharp,
              color: AppColors.white,
              size: 11,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  selectImageToTask(context: context, model: model),
            ),
          ),
        )
      ],
    );
  }
}

Widget selectImageToTask({context, model}) {
  return AlertDialog(
    title: Text(
      "Select Icon :",
      style: TextStyle(color: AppColors.deebOrangeS300),
    ),
    content: SizedBox(
      height: MediaQuery.of(context).size.height / 2.15,
      width: MediaQuery.of(context).size.width / 1.2,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: assetsImage.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) => circleImage(
          id: model['id'],
          context: context,
          image: assetsImage[index],
        ),
      ),
    ),
  );
}

Widget circleImage({required context, required id, required image}) => InkWell(
      child: CircleAvatar(backgroundImage: AssetImage(image), radius: 20),
      onTap: () {
        TodoAppCubit.get(context).updateImage(image: image, id: id);
        Navigator.pop(context);
      },
    );

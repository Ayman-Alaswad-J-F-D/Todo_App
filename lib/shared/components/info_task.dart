import 'package:flutter/material.dart';

import '../styles/colors.dart';

class InfoTask extends StatelessWidget {
  const InfoTask({Key? key, required this.model}) : super(key: key);

  final Map model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${model['title']}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${model['date']}',
            style: const TextStyle(color: AppColors.grey),
          ),
          Text(
            model['image'] != '' ? '${model['time']}' : '',
            style: const TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

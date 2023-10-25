import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/archive_tasks/archive_tasks_screen.dart';

import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../shared/components/background_header.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    this.height,
  }) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BackgroundHeader(
            height: height,
            headerLabel: DateFormat.yMMMMd().format(DateTime.now()),
            fontSize: 15,
            positionedTop: heightScreen(context) / 14,
            positionedBottom: null,
            fontWeight: FontWeight.normal,
            leadingIcon: Icons.archive_rounded,
            leadingClick: () => context.toScreen(
              screen: const ArchiveTasksScreen(),
            ),
          ),
        ),
        Positioned(
          top: heightScreen(context) / 7,
          left: 0,
          right: 0,
          child: const LabelWidget(
            title: 'My Todo List',
            fontSize: 28,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

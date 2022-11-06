// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context, {bool? isDone, bool? isArchive}) {
  var cubit = TodoAppCubit.get(context);

  return Dismissible(
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
    secondaryBackground: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
    confirmDismiss: (DismissDirection direction) async {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Delete Confirmation",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "Are you sure you want to delete this task ?",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    },
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      cubit.deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 20, bottom: 20, top: 20, end: 10),
      child: Row(
        children: [
          Stack(
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
                backgroundColor: Colors.deepOrange.shade300,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.edit_sharp,
                    size: 11,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Select Icon :",
                          style: TextStyle(color: Colors.deepOrange.shade300),
                        ),
                        content: SizedBox(
                          height: 160,
                          child: GridView.builder(
                            itemCount: assetsImage.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return circleImage(
                                context,
                                model['id'],
                                assetsImage[index],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          const SizedBox(width: 18.0),
          Expanded(
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
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  model['image'] != '' ? '${model['time']}' : '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const SizedBox(
            height: 20,
            width: 5,
            child: VerticalDivider(color: Colors.grey, thickness: 0.2),
          ),
          isArchive!
              ? IconButton(
                  splashColor: Colors.deepOrange.shade200,
                  onPressed: () {
                    cubit.updateStatus(status: 'done', id: model['id']);
                  },
                  icon: Icon(Icons.check_box_rounded,
                      color: Colors.deepOrange.shade300),
                )
              : const SizedBox(),
          isDone!
              ? IconButton(
                  splashColor: Colors.grey.shade200,
                  onPressed: () {
                    cubit.updateStatus(status: 'archive', id: model['id']);
                  },
                  icon:
                      const Icon(Icons.archive_rounded, color: Colors.black38),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

List<String> assetsImage = [
  'assets/eat_image.png',
  'assets/play_image.png',
  'assets/watching_image.png',
  'assets/sport_image.png',
  'assets/code_image.png',
  'assets/driving_image.png',
  'assets/tool-image.png',
  'assets/pencil_image.png',
  'assets/work_image.png',
  'assets/plane_image.png',
];

Widget circleImage(context, id, String image) => InkWell(
      onTap: () {
        TodoAppCubit.get(context).updateImage(image: image, id: id);
        Navigator.pop(context);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        minRadius: 25,
      ),
    );

////////////////////////////////////////

Widget addTask(
  context,
  formKey,
  titleConttroller,
  timeConttroller,
  dateConttroller,
) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              myTextFormField(
                textEditingController: titleConttroller,
                typeInput: TextInputType.text,
                label: 'Task Title',
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'title must not be empty';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.title),
              ),
              const SizedBox(height: 15),
              myTextFormField(
                textEditingController: timeConttroller,
                typeInput: TextInputType.datetime,
                label: 'Task Time',
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  )
                      .then(
                    (value) => timeConttroller.text =
                        value!.format(context).toString(),
                  )
                      .catchError((error) {
                    timeConttroller.text = '';
                  });
                },
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'time must not be empty';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.watch_later_outlined),
              ),
              const SizedBox(height: 15),
              myTextFormField(
                textEditingController: dateConttroller,
                typeInput: TextInputType.datetime,
                label: 'Task Date',
                onTap: () {
                  showDatePicker(
                    useRootNavigator: false,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2022-12-01'),
                  )
                      .then(
                    (value) => dateConttroller.text =
                        DateFormat.yMMMd().format(value!),
                  )
                      .catchError((error) {
                    dateConttroller.text = '';
                  });
                },
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'date must not be empty';
                  }
                  return null;
                },
                prefixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );

Widget tasksBulider({
  required List<Map> tasks,
  bool isDone = true,
  bool isArchive = true,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) {
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(
            tasks[index],
            context,
            isDone: isDone,
            isArchive: isArchive,
          ),
          separatorBuilder: (context, index) =>
              const Divider(indent: 20, height: 10),
          itemCount: tasks.length,
        );
      },
      fallback: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.menu_open_rounded, size: 80, color: Colors.black45),
              SizedBox(height: 20),
              Text(
                'No Tasks Yet, Please Add Some Tasks',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        );
      },
    );

Widget myTextFormField({
  required TextEditingController textEditingController,
  required TextInputType typeInput,
  required String label,
  double radius = 15.0,
  double gapPadding = 5.0,
  Icon? prefixIcon,
  IconData? suffixIcon,
  Function()? suffixPressed,
  Function()? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  String? Function(String?)? validate,
  bool isPassword = false,
  bool filledneed = false,
  Color fillColor = Colors.white,
  String? hintText,
  Color? colorHintText,
  double? fintSizeHintText,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      controller: textEditingController,
      keyboardType: typeInput,
      obscureText: isPassword,
      // style: const TextStyle(color: Colors.indigo),
      decoration: InputDecoration(
        filled: filledneed,
        fillColor: filledneed ? fillColor : Colors.white,
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Lora',
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorHintText,
          fontSize: fintSizeHintText,
        ),
        border: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffixIcon),
              )
            : null,
      ),
    );

void showToastShort({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.deepOrange.shade300;
      break;
  }
  return color;
}

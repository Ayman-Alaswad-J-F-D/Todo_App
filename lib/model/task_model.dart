import 'dart:convert';

class TaskModel {
  int id;
  String title, time, date, status, note, image;
  bool isArchive;

  TaskModel({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    required this.status,
    required this.note,
    required this.image,
    required this.isArchive,
  });

  factory TaskModel.fromMap(Map<String, dynamic> item) {
    return TaskModel(
      id: item['id'],
      title: item['title'],
      time: item['time'],
      date: item['date'],
      status: item['status'],
      note: item['note'],
      image: item['image'],
      isArchive: item['isArchive'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'date': date,
      'status': status,
      'note': note,
      'image': image,
      'isArchive': isArchive == true ? 1 : 0,
    };
  }

  @override
  String toString() => jsonEncode(toMap());
}

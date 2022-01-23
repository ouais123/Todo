import 'dart:convert';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "note": note,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "remind": remind,
      "repeat": repeat,
      "color": color,
      "isCompleted": isCompleted,
    };
  }

  Task.fromJosn(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    note = map["note"];
    date = map["date"];
    startTime = map["startTime"];
    endTime = map["endTime"];
    remind = map["remind"];
    repeat = map["repeat"];
    color = map["color"];
    isCompleted = map["isCompleted"];
  }
}

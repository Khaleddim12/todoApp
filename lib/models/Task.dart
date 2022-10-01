class Task {
  String? title;
  int? id;
  bool? isChecked;
  DateTime? reminderDate;
  int? reminderId;

  Task(
      {this.id,
      required this.title,
      this.isChecked = false,
      this.reminderDate,
      this.reminderId});


  void toggleDone() {
    isChecked = !isChecked!;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'title': title,
      'isChecked': isChecked == true ? 1 : 0
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'],
        title: map['title'],
        isChecked:   (map['isChecked'] as int)==1? true:false);

  }

  // Implement toString to make it easier to see information about
  // each Task when using the print statement.
  @override
  String toString() {
    return 'Task{id: $id, title: $title, isChecked: $isChecked}';
  }
}

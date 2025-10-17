class Course {
  final String name;
  final String time;

  Course({required this.name, required this.time});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
    };
  }
}

class Schedule {
  final String id;
  final String day;
  final List<Course> courses;

  Schedule({required this.id, required this.day, required this.courses});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var coursesFromJson = json['courses'] as List;
    List<Course> coursesList = coursesFromJson.map((i) => Course.fromJson(i)).toList();

    return Schedule(
      id: json['id'],
      day: json['day'],
      courses: coursesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'courses': courses.map((c) => c.toJson()).toList(),
    };
  }
}
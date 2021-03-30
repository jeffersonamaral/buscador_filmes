import 'people.dart';

class Crew extends People {
  String? _job;

  Crew.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    _job = map['job'];
  }

  String? get job => _job;

}
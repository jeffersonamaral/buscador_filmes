import 'people.dart';

class Cast extends People {
  int _order;

  Cast.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    _order = map['order'];
  }

  int get order => _order;

}
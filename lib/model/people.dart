abstract class People {
  int _id;

  String _name;

  People.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
  }

  String get name => _name;

  int get id => _id;

}
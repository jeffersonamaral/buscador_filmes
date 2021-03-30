abstract class People {
  int _id;

  String _name;

  People._internal(this._id, this._name);

  People.fromMap(Map<String, dynamic> map) : this._internal(map['id'], map['name']);

  String get name => _name;

  int get id => _id;

}
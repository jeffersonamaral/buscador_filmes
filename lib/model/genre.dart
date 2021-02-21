class Genre {
  int _id;

  String _name;

  Genre(this._id, this._name);

  Genre.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }

  String get name => _name;

  int get id => _id;

}
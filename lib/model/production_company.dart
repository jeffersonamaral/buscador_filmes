class ProductionCompany {
  int? _id;

  String? _name;

  ProductionCompany(this._id, this._name);

  ProductionCompany.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }

  String? get name => _name;

  int? get id => _id;

}
import 'package:buscador_filmes/model/production_company.dart';

import 'genre.dart';

class Movie {

  int _id;

  String _title;

  String _originalTitle;

  String _posterPath;

  List<Genre> _genres;

  String _voteAverage;

  String _releaseDate;

  String _overview;

  List<ProductionCompany> _productionCompanies;

  int _revenue;

  Movie.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _posterPath = map['poster_path'];

    if (map.containsKey('genres')) {
      _genres = List();

      for (Map<String, dynamic> aux in map['genres']) {
        _genres.add(Genre(aux['id'], aux['name']));
      }
    }

    _originalTitle = map['original_title'];
    _voteAverage = map['vote_average'].toString();
    _releaseDate = map['release_date'];

    if (map.containsKey('production_companies')) {
      _productionCompanies = List();

      for (Map<String, dynamic>  aux in map['production_companies']) {
        _productionCompanies.add(ProductionCompany.fromMap(aux));
      }
    }

    _overview = map['overview'];
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get originalTitle => _originalTitle;

  int get revenue => _revenue;

  set revenue(int value) {
    _revenue = value;
  }

  List<ProductionCompany> get productionCompanies => _productionCompanies;

  set productionCompanies(List<ProductionCompany> value) {
    _productionCompanies = value;
  }

  String get overview => _overview;

  set overview(String value) {
    _overview = value;
  }

  String get releaseDate => _releaseDate;

  set releaseDate(String value) {
    _releaseDate = value;
  }

  String get voteAverage => _voteAverage;

  set voteAverage(String value) {
    _voteAverage = value;
  }

  List<Genre> get genres => _genres;

  set genres(List<Genre> value) {
    _genres = value;
  }

  String get posterPath => _posterPath;

  set posterPath(String value) {
    _posterPath = value;
  }

  set originalTitle(String value) {
    _originalTitle = value;
  }

  String get genresLabel {
    String label = '';

    for (Genre genre in _genres) {
      label += '${genre.name} - ';
    }

    label = label.substring(0, (label.length - 1) - 2);

    return label;
  }

  String get productionCompaniesLabel {
    String label = '';

    for (ProductionCompany productionCompany in _productionCompanies) {
      label += '${productionCompany.name} - ';
    }

    label = label.substring(0, (label.length - 1) - 2);

    return label;
  }

  String get year {
    return _releaseDate.substring(0, 4);
  }

}
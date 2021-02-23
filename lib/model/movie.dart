import 'package:buscador_filmes/model/production_company.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'cast.dart';
import 'crew.dart';
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

  int _budget;

  int _runtime;

  List<Crew> _crew;

  List<Cast> _cast;

  String _theatricalReleaseDate;

  Movie.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _posterPath = map['poster_path'];

    _genres = List();

    if (map.containsKey('genres')) {
      for (Map<String, dynamic> aux in map['genres']) {
        _genres.add(Genre(aux['id'], aux['name']));
      }
    }

    _originalTitle = map['original_title'];
    _voteAverage = map['vote_average'].toString();
    _releaseDate = map['release_date'];
    _budget = map['budget'];

    _productionCompanies = List();

    if (map.containsKey('production_companies')) {
      for (Map<String, dynamic>  aux in map['production_companies']) {
        _productionCompanies.add(ProductionCompany.fromMap(aux));
      }
    }

    _runtime = map['runtime'];
    _overview = map['overview'];
    _cast = List();
    _crew = List();
  }

  int get id => _id;

  String get title => _title;

  String get originalTitle => _originalTitle;

  String get posterPath => _posterPath;

  List<Genre> get genres => _genres;

  String get voteAverage => _voteAverage;

  String get releaseDate => _releaseDate;

  String get overview => _overview;

  List<ProductionCompany> get productionCompanies => _productionCompanies;

  int get budget => _budget;

  int get runtime => _runtime;

  List<Crew> get crew => _crew;

  List<Cast> get cast => _cast;

  String get theatricalReleaseDate => _theatricalReleaseDate;

  set theatricalReleaseDate(String value) {
    _theatricalReleaseDate = value;
  }

  String get yearLabel {
    return _releaseDate.substring(0, 4);
  }

  String get genresLabel {
    String label = '';

    for (Genre genre in _genres) {
      label += '${genre.name} - ';
    }

    if (label.isNotEmpty) {
      label = label.substring(0, (label.length - 1) - 2);
    }

    return label;
  }

  String get productionCompaniesLabel {
    String label = '';

    for (ProductionCompany productionCompany in _productionCompanies) {
      label += '${productionCompany.name}, ';
    }

    if (label.isNotEmpty) {
      label = label.substring(0, (label.length - 1) - 1);
    }

    return label;
  }

  String get castLabel {
    String label = '';

    for (Cast cast in _cast) {
      if (cast.order <= 6) {
        label += '${cast.name}, ';
      }
    }

    if (label.isNotEmpty) {
      label = label.substring(0, (label.length - 1) - 1);
    }

    return label;
  }

  String get directorLabel {
    String label = '';

    for (Crew crew in _crew) {
      if (crew.job == 'Director') {
        label += '${crew.name}, ';
      }
    }

    if (label.isNotEmpty) {
      label = label.substring(0, (label.length - 1) - 1);
    }

    return label;
  }

  String get durationLabel {
    int hours = _runtime ~/ 60;
    int minutes = (_runtime - (hours * 60));

    return '${hours}h $minutes min';
  }

  String get budgetLabel {
    String label;

    if (_budget != null && _budget != 0) {
      label = NumberFormat.currency(
        decimalDigits: 0,
        locale: 'en-US',
        symbol: '\$'
      ).format(_budget);
    } else {
      label = 'Indisponível';
    }

    return label;
  }

  String get theatricalReleaseDateLabel {
    String label;

    if (_theatricalReleaseDate != null && _theatricalReleaseDate.isNotEmpty) {
      initializeDateFormatting();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime dateTime = formatter.parse(_theatricalReleaseDate);
      DateFormat labelFormatterDay = DateFormat('dd', 'pt-BR');
      DateFormat labelFormatterMonth = DateFormat('MMMM', 'pt-BR');

      label = labelFormatterDay.format(dateTime) + ' de ' + labelFormatterMonth.format(dateTime);
    }

    return label;
  }

}
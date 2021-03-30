import 'package:buscador_filmes/view/widget/details.dart';
import 'package:flutter/material.dart';

import '../view/widget/home.dart';
import '../model/movie.dart';

/*
 * Jefferson Amaral da Silva
 * 25/11/2020
 */
class RouteGenerator {

  static const home = '/';

  static const details = '/details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            }
        );

      case details:
        return MaterialPageRoute(
            builder: (BuildContext context) {
              return Details(settings.arguments as Movie);
            }
        );

        break;

      default:
        throw Exception('Invalid Route: ${settings.name}');
    }
  }
}
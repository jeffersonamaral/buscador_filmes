import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'util/route_generator.dart';
import 'view/widget/home.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  // debugRepaintRainbowEnabled = true;

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Buscador de Filmes',
          initialRoute: RouteGenerator.home,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.blueGrey,
            textSelectionColor: Colors.blue,
          ),
          home: Home()
      )
  );
}
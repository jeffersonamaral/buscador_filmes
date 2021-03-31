import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'util/route_generator.dart';
import 'view/widget/home.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Buscador de Filmes',
          initialRoute: RouteGenerator.home,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.blueGrey,
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: Colors.blue
            ),
          ),
          home: Home()
      ),
      enabled: true,
    )
  );
}
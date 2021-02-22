import 'dart:convert';

import 'package:buscador_filmes/model/genre.dart';
import 'package:buscador_filmes/model/movie.dart';
import 'package:buscador_filmes/util/route_generator.dart';
import 'package:buscador_filmes/util/project_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'search_list_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerSearch = TextEditingController();
  List<Genre> _genres = List();
  List<Movie> _movies = List();

  @override
  void initState() {
    super.initState();

    _searchGenres();
  }

  _search(String value) async {
    _movies.clear();

    if (value == null) {
      return _movies;
    }

    var url = searchMoviesUrl + value;
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Movie movie;
      List<Movie> tempMovies = List();
      var jsonResponse = json.decode(response.body);

      for (Map<String, dynamic> mapMovie in jsonResponse['results']) {
        setState(() {
          movie = Movie.fromMap(mapMovie);
          movie.genres = List();

          for (int genreId in mapMovie['genre_ids']) {
            for (Genre genre in _genres) {
              if (genre.id == genreId) {
                movie.genres.add(genre);
                break;
              }
            }
          }

          tempMovies.add(movie);
        });
      }

      _movies = tempMovies;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _searchGenres() async {
    var url = searchGenresUrl;
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      for (Map<String, dynamic> aux in jsonResponse['genres']) {
        _genres.add(Genre.fromMap(aux));
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Widget _createListTile(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteGenerator.details, arguments: _movies[index]);
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: SearchListTile(movie: _movies[index])
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _controllerSearch,
                autofocus: false,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff707880)
                ),
                decoration: InputDecoration(
                  hintText: 'Pesquise Filmes',
                  filled: true,
                  fillColor: Color(0xfff1f3f5),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xfff1f3f5),
                        width: 10,
                        style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    _search(_controllerSearch.text);
                  });
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child:             Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: 0,
                  spacing: 5.0,
                  children: [
                    FlatButton(
                      onPressed: () {},
                      color: Color(0xff00384c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Colors.white
                        ),
                      ),
                      child: Text(
                          'Ação',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          )
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      color: Color(0xff00384c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Colors.white
                        ),
                      ),
                      child: Text(
                          'Aventura',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          )
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      color: Color(0xff00384c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Colors.white
                        ),
                      ),
                      child: Text(
                          'Fantasia',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          )
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      color: Color(0xff00384c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                            color: Colors.white
                        ),
                      ),
                      child: Text(
                          'Comédia',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          )
                      ),
                    ),
                  ],
                )
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      return _createListTile(context, index);
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
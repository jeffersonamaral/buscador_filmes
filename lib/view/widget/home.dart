import 'dart:convert';

import 'package:buscador_filmes/model/genre.dart';
import 'package:buscador_filmes/model/movie.dart';
import 'package:buscador_filmes/util/project_constants.dart';
import 'package:buscador_filmes/util/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'search_list_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController _controllerSearch = TextEditingController();
  List<Genre> _genres = [];
  List<Movie> _movies = [];

  List<Movie> _moviesAction = [];
  List<Movie> _moviesAdventure = [];
  List<Movie> _moviesFantasy = [];
  List<Movie> _moviesComedy = [];

  int _selectedTabIndex = 0;

  bool _searching = false;

  @override
  void initState() {
    super.initState();

    _searchGenres();

    _tabController = TabController(
        length: 4,
        vsync: this
    );

    _search(null);
  }

  _search(String? value) async {
    setState(() {
      _searching = true;
    });

    _movies.clear();

    String url;

    if (value != null && value.isNotEmpty) {
      url = searchMoviesUrl + value;
    } else {
      url = searchMoviesbyGenreUrl;
    }

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Movie movie;
      List<Movie> tempMovies = [];
      List<Movie> tempMoviesAction = [];
      List<Movie> tempMoviesAdventure = [];
      List<Movie> tempMoviesFantasy = [];
      List<Movie> tempMoviesComedy = [];

      var jsonResponse = json.decode(response.body);

      for (Map<String, dynamic> mapMovie in jsonResponse['results']) {
        setState(() {
          movie = Movie.fromMap(mapMovie);

          for (int genreId in mapMovie['genre_ids']) {
            for (Genre genre in _genres) {
              if (genre.id == genreId) {
                movie.genres!.add(genre);
                break;
              }
            }
          }

          tempMovies.add(movie);
        });
      }

      _movies = tempMovies;

      for (Movie auxMovie in _movies) {
        for (Genre auxGenre in auxMovie.genres!) {
          if (auxGenre.id == 28) {
            tempMoviesAction.add(auxMovie);
          }

          if (auxGenre.id == 12) {
            tempMoviesAdventure.add(auxMovie);
          }

          if (auxGenre.id == 14) {
            tempMoviesFantasy.add(auxMovie);
          }

          if (auxGenre.id == 35) {
            tempMoviesComedy.add(auxMovie);
          }
        }
      }

      setState(() {
        _moviesAction = tempMoviesAction;
        _moviesAdventure = tempMoviesAdventure;
        _moviesFantasy = tempMoviesFantasy;
        _moviesComedy = tempMoviesComedy;
        _searching = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Falha na requisição: ${response.statusCode}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER
      );

      setState(() {
        _moviesAction = [];
        _moviesAdventure = [];
        _moviesFantasy = [];
        _moviesComedy = [];
        _searching = false;
      });
    }
  }

  void _searchGenres() async {
    var url = searchGenresUrl;
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      for (Map<String, dynamic> aux in jsonResponse['genres']) {
        _genres.add(Genre.fromMap(aux));
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Falha na requisição: ${response.statusCode}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER
      );
    }
  }

  Widget _createListTile(BuildContext context, int index, int tab) {
    late List<Movie> tempList;

    switch (tab) {
      case 0:
        tempList = _moviesAction;
        break;
      case 1:
        tempList = _moviesAdventure;
        break;
      case 2:
        tempList = _moviesFantasy;
        break;
      case 3:
        tempList = _moviesComedy;
        break;
    }

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context,
              RouteGenerator.details,
              arguments: tempList[index]
          );
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: SearchListTile(
                movie: tempList[index]
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return apiKey == 'INSERIR_API_KEY_AQUI'
        ? Container(
      child: Center(
        child: Text(
          'O valor de \"apiKey\" em util/project_constants.dart deve ser alterado para uma apiKey válida antes de se iniciar o app.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 23,
              color: Colors.red[900],
          ),
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
          title: Text('Filmes'),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight * 2),
            child: Column(
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
                        hintText: 'Pesquise filmes',
                        filled: true,
                        fillColor: Color(0xfff1f3f5),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon: _controllerSearch.text != null && _controllerSearch.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  _controllerSearch.clear();
                                  _search(null);
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xfff1f3f5),
                              width: 10,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xfff1f3f5),
                              width: 0,
                              style: BorderStyle.solid
                          ),
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _search(_controllerSearch.text);
                    },
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  onTap: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: _selectedTabIndex == 0
                                  ? Color(0xff00384c)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Text(
                            'Ação',
                            style: TextStyle(
                              color: _selectedTabIndex == 0
                                  ? Colors.white
                                  : Color(0xff868e96),
                              fontSize: 14,
                            ),
                          )
                      ),
                    ),
                    Tab(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: _selectedTabIndex == 1
                                  ? Color(0xff00384c)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Text(
                            'Aventura',
                            style: TextStyle(
                              color: _selectedTabIndex == 1
                                  ? Colors.white
                                  : Color(0xff868e96),
                              fontSize: 14,
                            ),
                          )
                      ),
                    ),
                    Tab(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: _selectedTabIndex == 2
                                  ? Color(0xff00384c)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Text(
                            'Fantasia',
                            style: TextStyle(
                              color: _selectedTabIndex == 2
                                  ? Colors.white
                                  : Color(0xff868e96),
                              fontSize: 14,
                            ),
                          )
                      ),
                    ),
                    Tab(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: _selectedTabIndex == 3
                                  ? Color(0xff00384c)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          ),
                          child: Text(
                            'Comédia',
                            style: TextStyle(
                              color: _selectedTabIndex == 3
                                  ? Colors.white
                                  : Color(0xff868e96),
                              fontSize: 14,
                            ),
                          )
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: _searching ? Center(child: CircularProgressIndicator()) : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: _moviesAction.isEmpty
                        ? Center(child: Text('Nada encontrado :(', style: TextStyle(fontSize: 30),))
                        : ListView.builder(
                              itemCount: _moviesAction.length,
                              itemBuilder: (context, index) {
                                return _createListTile(context, index, 0);
                              }
                          )
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: _searching ? Center(child: CircularProgressIndicator()) : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: _moviesAdventure.isEmpty
                        ? Center(child: Text('Nada encontrado :(', style: TextStyle(fontSize: 30),))
                        : ListView.builder(
                        itemCount: _moviesAdventure.length,
                        itemBuilder: (context, index) {
                          return _createListTile(context, index, 1);
                        }
                    )
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: _searching ? Center(child: CircularProgressIndicator()) : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: _moviesFantasy.isEmpty
                        ? Center(child: Text('Nada encontrado :(', style: TextStyle(fontSize: 30),))
                        : ListView.builder(
                        itemCount: _moviesFantasy.length,
                        itemBuilder: (context, index) {
                          return _createListTile(context, index, 2);
                        }
                    )
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: _searching ? Center(child: CircularProgressIndicator()) : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: _moviesComedy.isEmpty
                        ? Center(child: Text('Nada encontrado :(', style: TextStyle(fontSize: 30),))
                        : ListView.builder(
                        itemCount: _moviesComedy.length,
                        itemBuilder: (context, index) {
                          return _createListTile(context, index, 3);
                        }
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
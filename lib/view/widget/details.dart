import 'dart:convert';

import 'package:buscador_filmes/model/genre.dart';
import 'package:buscador_filmes/model/movie.dart';
import 'package:buscador_filmes/view/widget/please_wait.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'error_message.dart';

const _posterBaseUrl = 'https://image.tmdb.org/t/p/original/';

class Details extends StatelessWidget {
  final Movie _movie;

  Details(this._movie);

  Future<Movie> _searchMovieDetails(Movie movie) async {
    Movie detailedMovie;

    var url = 'https://api.themoviedb.org/3/movie/${movie.id}?api_key=23b53de489b329a894ceb74dc49f64c1&language=pt-BR';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Movie movie;
      List<Movie> tempMovies = List();
      var jsonResponse = json.decode(response.body);

      detailedMovie = Movie.fromMap(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return detailedMovie;
  }

  List<Widget> _createGenresRow(Movie movie) {
    List<Widget> widgets = List<Widget>();

    for (Genre genre in movie.genres) {
      widgets.add(
          Container(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xfff1f3f5),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Text(
                genre.name.toUpperCase(),
                style: TextStyle(
                    color: Color(0xff5e6770),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              )
          )
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          floatingActionButton: Padding(
              padding: EdgeInsets.only(top: 30),
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).pop(),
                elevation: 0,
                backgroundColor: Colors.white,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff6d7070),
                ),
                label: Text(
                  'Voltar',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff6d7070)
                  ),
                ),
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          body: FutureBuilder<Movie>(
            future: _searchMovieDetails(_movie),
            builder: (context, snapshot) {
              Widget result;

              switch (snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  result = PleaseWait();

                  break;

                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    result = ErrorMessage();
                  } else {
                    result = SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            color: Colors.white, //Color(0xfff5f5f5),
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                                padding: EdgeInsets.only(top: 180),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.network(
                                                _posterBaseUrl + snapshot.data.posterPath,
                                                width: MediaQuery.of(context).size.width * 0.6,
                                              ),
                                            )
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            'NOS CINEMAS',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 40, bottom: 40),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data.voteAverage,
                                            style: TextStyle(
                                                color: Color(0xff00384c),
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            ' / 10',
                                            style: TextStyle(
                                                color: Color(0xff868e96),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.title.toUpperCase(),
                                      style: TextStyle(
                                          color: Color(0xff00384c),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial'
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 40),
                                        child: Text(
                                          'Título original: ${snapshot.data.originalTitle}',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),
                                        )
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          decoration: BoxDecoration(
                                              color: Color(0xfff1f3f5),
                                              border: Border.all(
                                                color: Color(0xfff1f3f5),
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Ano: ',
                                                style: TextStyle(
                                                    color: Color(0xff868e96),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                snapshot.data.year,
                                                style: TextStyle(
                                                    color: Color(0xff343a40),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox.fromSize(size: Size(20, 20)),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          decoration: BoxDecoration(
                                              color: Color(0xfff1f3f5),
                                              border: Border.all(
                                                color: Color(0xfff1f3f5),
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(8))
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Duração: ',
                                                style: TextStyle(
                                                    color: Color(0xff868e96),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                '1h 20 min',
                                                style: TextStyle(
                                                    color: Color(0xff343a40),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox.fromSize(size: Size(20, 15)),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: _createGenresRow(snapshot.data),
                                    ),
                                    SizedBox.fromSize(size: Size(20, 75)),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'Descrição',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        snapshot.data.overview,
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                        )
                    );
                  }
                  break;
              }

              return result;
            },
          )
      ),
    );
  }
}
import 'dart:convert';

import 'package:buscador_filmes/model/cast.dart';
import 'package:buscador_filmes/model/crew.dart';
import 'package:buscador_filmes/model/genre.dart';
import 'package:buscador_filmes/model/movie.dart';
import 'package:buscador_filmes/util/project_constants.dart';
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

    var url = '${searchDetailsUrl + movie.id.toString()}?api_key=$apiKey&language=pt-BR';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      detailedMovie = Movie.fromMap(jsonResponse);

      var urlCredits = '${searchCreditsUrl + movie.id.toString()}/credits?api_key=$apiKey';
      var responseCredits = await http.get(urlCredits);

      if (responseCredits.statusCode == 200) {
        var jsonResponseCredits = json.decode(responseCredits.body);

        for (Map<String, dynamic> auxCast in jsonResponseCredits['cast']) {
          detailedMovie.cast.add(Cast.fromMap(auxCast));
        }

        for (Map<String, dynamic> auxCrew in jsonResponseCredits['crew']) {
          detailedMovie.crew.add(Crew.fromMap(auxCrew));
        }

        var urlReleaseDates = '${searchCreditsUrl + movie.id.toString()}/release_dates?api_key=$apiKey';
        var responseReleaseDates = await http.get(urlReleaseDates);

        if (responseReleaseDates.statusCode == 200) {
          var jsonResponseReleaseDates = json.decode(responseReleaseDates.body);

          for (Map<String, dynamic> auxReleaseDates in jsonResponseReleaseDates['results']) {
            if (auxReleaseDates['iso_3166_1'] == 'BR') {
              for (Map<String, dynamic> aux in auxReleaseDates['release_dates']) {
                // Testando se a release_date é para os cinemas
                if (aux['type'] == 3) {
                  detailedMovie.theatricalReleaseDate = aux['release_date'];

                  if (detailedMovie.theatricalReleaseDate != null && detailedMovie.theatricalReleaseDate?.isNotEmpty) {
                    detailedMovie.theatricalReleaseDate = detailedMovie.theatricalReleaseDate.substring(0, 10);
                  }

                  break;
                }
              }
            }
          }
        } else {
          print('Request failed with status: ${responseReleaseDates.statusCode}.');
        }
      } else {
        print('Request failed with status: ${responseCredits.statusCode}.');
      }
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
    return Scaffold(
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
                  result = Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Image.asset(
                                  'assets/img/details_background.png',
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.4,
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 180, left: 25, right: 25),
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
                                          Positioned(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              bottom: 10,
                                              child: Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Text(
                                                    snapshot.data.theatricalReleaseDateLabel != null
                                                        ? '${snapshot.data.theatricalReleaseDateLabel.toUpperCase()} NOS CINEMAS'
                                                        : '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              )
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
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        runSpacing: 10,
                                        spacing: 10,
                                        alignment: WrapAlignment.center,
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
                                              mainAxisSize: MainAxisSize.min,
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
                                                  snapshot.data.yearLabel,
                                                  style: TextStyle(
                                                      color: Color(0xff343a40),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
                                              mainAxisSize: MainAxisSize.min,
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
                                                  snapshot.data.durationLabel,
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
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            snapshot.data.overview != null && snapshot.data.overview.isNotEmpty
                                                ? snapshot.data.overview
                                                : 'Indisponível',
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                        )
                                      ),
                                      SizedBox.fromSize(size: Size(20, 50)),
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
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'ORÇAMENTO: ',
                                                  style: TextStyle(
                                                      color: Color(0xff868e96),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.budgetLabel,
                                                  style: TextStyle(
                                                      color: Color(0xff343a40),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ]
                                          )
                                      ),
                                      SizedBox.fromSize(size: Size(20, 5)),
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
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'PRODUTORAS: ',
                                                  style: TextStyle(
                                                      color: Color(0xff868e96),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(
                                                  '${snapshot.data.productionCompaniesLabel}',
                                                  style: TextStyle(
                                                      color: Color(0xff343a40),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ]
                                          )
                                      ),
                                      SizedBox.fromSize(size: Size(20, 50)),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Diretor',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              snapshot.data.directorLabel,
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox.fromSize(size: Size(20, 50)),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Elenco',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              snapshot.data.castLabel,
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox.fromSize(size: Size(20, 50)),
                                    ],
                                  )
                              )
                            ],
                          )
                      )
                  );
                }
                break;
            }

            return result;
          },
        )
    );
  }
}
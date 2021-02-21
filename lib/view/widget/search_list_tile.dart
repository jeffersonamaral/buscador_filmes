import 'package:buscador_filmes/model/movie.dart';
import 'package:flutter/material.dart';

const _posterBaseUrl = 'https://image.tmdb.org/t/p/original/';

class SearchListTile extends StatelessWidget {

  final Movie _movie;

  SearchListTile({@required movie}) : this._movie = movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(_posterBaseUrl + _movie.posterPath),
          ),
          Positioned(
              left: 20,
              bottom: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        _movie.title.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  Text(
                    _movie.genresLabel,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
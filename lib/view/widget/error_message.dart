import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Ocorreu um erro!\nTente novamente mais tarde.',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            )
          ],
        )
    );
  }
}

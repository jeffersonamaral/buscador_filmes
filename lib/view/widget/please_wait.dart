import 'package:flutter/material.dart';

class PleaseWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Por favor, aguarde.',
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

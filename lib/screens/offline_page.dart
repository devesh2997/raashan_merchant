import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class OfflinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.8,
              child: FlareActor(
                'assets/flares/no_connection.flr',
                animation: "init",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'You seem to be offline.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                  Text(
                    'Please check your internet connection.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

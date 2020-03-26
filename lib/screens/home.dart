import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/data/user_repository.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Home'),
        MaterialButton(
          child: Text('Logout'),
          onPressed: () {
            Provider.of<UserRepository>(context).signOut();
          },
        )
      ],
    );
  }
}

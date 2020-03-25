import 'dart:io';

import 'package:flutter/material.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/bottom_sheets/alert_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class CompulsoryUpdateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertSheet(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'We have some good news and some bad news.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'We are constantly working to improve your experience and we have got an exciting update for you.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Unfortunately, we have stopped supporting the version of the app that you are using. So you will have to update the app to continue enjoying our services.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  color: getPrimaryColor(),
                  child: Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    try {
                      if (Platform.isAndroid) {
                        launch(
                            'https://play.google.com/store/apps/details?id=in.raashan_merchant.raashan_merchant_app');
                      } else if (Platform.isIOS) {
                        launch(
                            'https://apps.apple.com/us/app/raashan_merchant/id1491352619?ls=1');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

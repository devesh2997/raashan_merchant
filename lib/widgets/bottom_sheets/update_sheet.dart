import 'package:flutter/material.dart';
import 'package:raashan_merchant/services/navigation.service.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/bottom_sheets/alert_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class UpdateSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Good news!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(1)),
                    padding: EdgeInsets.symmetric(vertical: 5.5),
                    child: Center(
                      child: Text(
                        'Not Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    NavigationService.of(context).pop();
                  },
                ),
              ),
              SizedBox(width: 20),
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

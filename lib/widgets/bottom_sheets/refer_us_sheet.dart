import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:raashan_merchant/screens/login_page.dart';
import 'package:raashan_merchant/services/navigation.service.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/bottom_sheets/alert_sheet.dart';

class ReferUsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Select Platform',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icon/android.png',
                        width: 40,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Android',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    NavigationService.of(context).pop();
                    Share.share(
                        'https://play.google.com/store/apps/details?id=in.raashan_merchant.raashan_merchant_app');
                  },
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icon/ios.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        'IOS',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    NavigationService.of(context).pop();
                    Share.share(
                        'https://apps.apple.com/us/app/raashan_merchant/id1491352619?ls=1');
                  },
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icon/web.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        'Web',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    NavigationService.of(context).pop();
                    Share.share('https://www.raashan_merchant.in');
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

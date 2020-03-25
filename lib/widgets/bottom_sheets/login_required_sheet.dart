import 'package:flutter/material.dart';
import 'package:raashan_merchant/screens/login_page.dart';
import 'package:raashan_merchant/services/navigation.service.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/bottom_sheets/alert_sheet.dart';

class LoginRequiredSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Please login to proceed.',
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
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    NavigationService.of(context).pop();
                    NavigationService.of(context).pushPage(LoginPage());
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

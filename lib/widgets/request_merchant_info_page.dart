import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/data/merchant_repository.dart';
import 'package:raashan_merchant/models/merchant_info.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/under_line.dart';

import 'country_code_selector.dart';

class RequestUserInfoPage extends StatefulWidget {
  final MerchantInfo merchantInfo;

  const RequestUserInfoPage({Key key, this.merchantInfo}) : super(key: key);
  @override
  _RequestUserInfoPageState createState() => _RequestUserInfoPageState();
}

class _RequestUserInfoPageState extends State<RequestUserInfoPage> {
  bool submittingInfo;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController mobileController;
  String countryCode;
  @override
  void initState() {
    super.initState();
    MerchantInfo merchantInfo = widget.merchantInfo;
    nameController = TextEditingController();
    mobileController = TextEditingController();
    nameController.text = beautifyName(merchantInfo.name);
    if (merchantInfo.mobile != null && merchantInfo.mobile.length > 0) {
      if (merchantInfo.mobile[0] == '+') {
        if (merchantInfo.mobile[1] == '9' && merchantInfo.mobile[2] == '1') {
          mobileController.text = merchantInfo.mobile.substring(3);
        }
      } else {
        mobileController.text = merchantInfo.mobile;
      }
    }
    submittingInfo = false;
    countryCode = '+91';
  }

  _setCountryCode(code) {
    if (code.toString() != '+91')
      setState(() {
        countryCode = code.toString();
      });
  }

  Widget buildMobileInput() {
    return Theme(
      data: ThemeData(primaryColor: Colors.blue),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: <Widget>[
            CountryCodeSelector(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                letterSpacing: 2,
                fontFamily: 'Questrial',
              ),
              initialSelection: 'IN',
              favorite: ['+91', 'IN'],
            ),
            Expanded(
              child: TextFormField(
                enabled: false,
                validator: (value) {
                  return validateMobile(value, countryCode)
                      ? null
                      : 'Invalid mobile number.';
                },
                cursorColor: Colors.black,
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  contentPadding: EdgeInsets.all(4),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: getAccentColor(),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double spacing = size.height * 0.03;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Hey There!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Help us get to know you better.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  UnderLine(
                    width: size.width * 0.50,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    // Text('What should we call you ?'),
                    TextFormField(
                      validator: (value) {
                        return value.isEmpty ? 'Invalid Name' : null;
                      },
                      autofocus: false,
                      cursorColor: Colors.blue.shade500,
                      controller: nameController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.black54),
                        contentPadding: EdgeInsets.all(4),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: getAccentColor(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    buildMobileInput(),
                    SizedBox(
                      height: spacing,
                    ),
                    if (submittingInfo)
                      CircularProgressIndicator()
                    else
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                padding: EdgeInsets.all(0),
                                child: Text("CANCEL"),
                                onPressed: () {
                                  if (Navigator.of(context).canPop())
                                    Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                padding: EdgeInsets.all(0),
                                color: getPrimaryColor(),
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    submittingInfo = true;
                                  });
                                  if (_formKey.currentState.validate()) {
                                    await Provider.of<MerchantRepository>(context)
                                        .updateUserInfo(
                                      name: nameController.text,
                                      mobile:
                                          countryCode + mobileController.text,
                                    );
                                  }
                                  if (mounted)
                                    setState(() {
                                      submittingInfo = false;
                                    });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 50, left: 50, right: 50, bottom: 50),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: getPrimaryColor(),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: RawMaterialButton(
                        onPressed: () {
                          Provider.of<MerchantRepository>(context).signOut();
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: getPrimaryColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


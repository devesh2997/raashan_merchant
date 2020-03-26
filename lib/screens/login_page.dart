import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/data/merchant_repository.dart';
import 'package:raashan_merchant/services/navigation.service.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/country_code_selector.dart';

class LoginPage extends StatefulWidget {
  final bool redirect;

  const LoginPage({Key key, this.redirect: false}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryCode;

  final _mobileFormKey = GlobalKey<ScaffoldState>();
  final _otpFormKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController loginCredController;
  TextEditingController otpController;
  PageController pageController;

  bool loadingStrategy;
  bool phoneAllowed;
  bool googleAllowed;

  @override
  void initState() {
    super.initState();
    loginCredController = TextEditingController();
    otpController = TextEditingController();
    countryCode = "+91";
    pageController = PageController(initialPage: 0);
  }

  _setCountryCode(code) {
    if (code.toString() != '+91')
      setState(() {
        countryCode = code.toString();
      });
  }

  Widget _toggle(MerchantRepository userRepository) {
    Status status = userRepository.status;
    if (status == Status.Authenticating) {
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    return FloatingActionButton(
      backgroundColor: getPrimaryColor(),
      onPressed: () async {
        if (status != Status.CodeSent) {
          print(countryCode + loginCredController.text);
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          await userRepository
              .verifyPhoneNumber(countryCode + loginCredController.text);
          // if (codeSent) {
          //   if (pageController.hasClients) {
          //     pageController.animateToPage(
          //       1,
          //       duration: Duration(seconds: 1),
          //       curve: Curves.easeOutExpo,
          //     );
          //   }
          // }
        } else {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          await userRepository.signInWithPhoneNumber(otpController.text);
        }
      },
      child: Icon(
        Icons.navigate_next,
        color: Colors.white,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MerchantRepository userRepository = Provider.of<MerchantRepository>(context);
    Status status = userRepository.status;
    if (status == Status.Authenticated) {
      if (widget.redirect) {
        NavigationService.of(context).pop();
      }
    } else if (status == Status.CodeSent) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          1,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutExpo,
        );
      }
    } else if (status == Status.Unauthenticated) {
      if (pageController.hasClients) {
        pageController.animateToPage(
          0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutExpo,
        );
      }
    }
  }

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget _getForm(MerchantRepository userRepository) {
    Status status = userRepository.status;
    String message = userRepository.message;

    return PageView(
      controller: pageController,
      children: <Widget>[
        Form(
          key: _mobileFormKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      'Enter your mobile number to continue. ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: buildInput(status),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Center(
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Form(
          key: _otpFormKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Sit back and relax while we verify your mobile number. ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: buildInput(status),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 40, 15, 10),
                child: GestureDetector(
                  onTap: () {
                    userRepository.reset();
                  },
                  child: Text(
                    'Change Mobile Number',
                    style: TextStyle(
                      color: getAccentColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MerchantRepository userRepository = Provider.of<MerchantRepository>(context);
    return Scaffold(
      key: _key,
      floatingActionButton: _toggle(userRepository),
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  'Raashan - Merchant',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.redirect
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.keyboard_arrow_left),
                color: Colors.black,
              )
            : Container(),
      ),
      body: _getForm(userRepository),
    );
  }

  Widget buildInput(Status status) {
    if (status == Status.CodeSent) {
      loginCredController.text = '';
      return Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 0, 60, 0),
        child: TextField(
          autofocus: true,
          cursorColor: Colors.blue.shade500,
          controller: otpController,
          keyboardType: TextInputType.numberWithOptions(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
      );
    } else {
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
                ),
                onChanged: (value) => _setCountryCode(value),
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'IN',
                favorite: ['+91', 'IN'],
              ),
              Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                  controller: loginCredController,
                  keyboardType: TextInputType.numberWithOptions(),
                  style: TextStyle(
                    color: Colors.black,
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
  }

  Widget buildSubText(Status status) {
    if (status == Status.CodeSent) {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'We have sent a verification code to your mobile.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(height: 0);
    }
  }
}

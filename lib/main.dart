import 'dart:js';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/providers/connectivity_provider.dart';
import 'package:raashan_merchant/screens/offline_page.dart';
import 'package:raashan_merchant/services/navigation.service.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool hasConnection =
        Provider.of<ConnectivityProvider>(context).hasConnection ?? true;
    return hasConnection ? MyApp() : OfflinePage();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      backgroundColor: Colors.black54.withOpacity(0.8),
      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      radius: 5,
      textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      position: ToastPosition(align: Alignment.topCenter, offset: 80),
      dismissOtherOnShow: true,
      child: MaterialApp(
        title: 'Raashan Merchant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: NavigationService.of(context).createRoutes(),
      ),
    );
  }
}

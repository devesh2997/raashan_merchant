import 'package:flutter/material.dart';

const bool ENABLE_DEVICE_SIMULATION = false;

class NavigationService {
  final BuildContext context;

  NavigationService(this.context);

  factory NavigationService.of(BuildContext context) {
    return NavigationService(context);
  }

  Map<String, Widget Function(BuildContext)> createRoutes() {
    Map<String, Widget Function(BuildContext)> routes;
    routes = {
      '/': (context) => Scaffold(
            appBar: AppBar(
              title: Text(
                "Raashan Merchant",
              ),
            ),
            body: Center(
              child: Text(
                "Raashan",
              ),
            ),
          ),
    };
    return routes;
  }

  pop() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      print('cannot pop');
    }
  }

  goToLanding() {
    Navigator.of(context).popUntil(
      ModalRoute.withName('/landing'),
    );
  }

  pushPageOnLanding(
    Widget page,
  ) {
    Navigator.of(context).pushAndRemoveUntil(
        createMaterialPageRoute(page), (Route<dynamic> route) => false);
  }

  pushReplacementPage(Widget page) {
    Navigator.of(context).pushReplacement(createMaterialPageRoute(page));
  }

  pushNamedReplacementPage(String page) {
    Navigator.of(context).pushReplacementNamed(page);
  }

  pushPage(Widget page, {bool fade = false}) {
    if (fade) {
      Navigator.of(context).push(
        FadeRoute(page: page),
      );
    } else
      Navigator.of(context).push(
        createMaterialPageRoute(page),
      );
  }

  pushNamedPage(String page) {
    Navigator.of(context).pushNamed(page);
  }

  Route createMaterialPageRoute(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

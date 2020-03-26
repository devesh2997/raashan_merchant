import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/providers/connectivity_provider.dart';
import 'package:raashan_merchant/providers/update_provider.dart';
import 'package:raashan_merchant/widgets/compulsory_update.dart';
import 'package:raashan_merchant/widgets/with_authentication.dart';
import 'landing.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider.instance(context),
      child: Consumer<UpdateProvider>(
        builder: (context, UpdateProvider updateProvider, _) {
          switch (updateProvider.status) {
            case UpdateStatus.Loading:
              // return WithAuthentication(child: Landing());
              return SplashView();
              break;
            case UpdateStatus.Compulsory:
              return Scaffold(
                backgroundColor: Colors.white,
                body: CompulsoryUpdateView(),
              );
              break;
            case UpdateStatus.Latest:
            case UpdateStatus.Safe:
            case UpdateStatus.Optional:
              return WithAuthentication(child: Landing());
              break;
            default:
              return SplashView();
              return WithAuthentication(child: Landing());
              break;
          }
        },
      ),
    );
  }
}

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SizedBox(
            height: 200,
            child: Text('Logo goes here'),
          ),
        ),
      ),
    );
  }
}

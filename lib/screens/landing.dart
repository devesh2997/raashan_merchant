import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raashan_merchant/providers/update_provider.dart';
import 'package:raashan_merchant/screens/account.dart';
import 'package:raashan_merchant/screens/home.dart';
import 'package:raashan_merchant/utils/utils.dart';
import 'package:raashan_merchant/widgets/bottom_app_bar_item.dart';
import 'package:raashan_merchant/widgets/bottom_sheets/update_sheet.dart';

enum Page { Home, Account, Cart, Wishlist }

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  Page selectedPage = Page.Home;
  bool showedUpdateSheet;
  @override
  void initState() {
    selectedPage = Page.Home;
    showedUpdateSheet = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //check for updates
    UpdateStatus updateStatus = Provider.of<UpdateProvider>(context).status;
    if (updateStatus == UpdateStatus.Optional) {
      Future.delayed(Duration(seconds: 3), () {
        if (!showedUpdateSheet) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return UpdateSheet();
            },
          );
          setState(() {
            showedUpdateSheet = true;
          });
        }
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: UKBottomAppBar(
        selectedPage: selectedPage,
        onPageSelected: setSelectedPage,
      ),
      drawer: UKDrawer(),
      body: _getPage(context),
    );
  }

  Widget _getPage(BuildContext context) {
    switch (selectedPage) {
      case Page.Home:
        return Home();
        break;
      case Page.Account:
        return Account();
        break;
      default:
        return Home();
    }
  }

  void setSelectedPage(Page page) {
    setState(() {
      selectedPage = page;
    });
  }
}

class UKDrawer extends StatelessWidget {
  const UKDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer'),
          ),
          ListTile(
            title: Text('TODO'),
          ),
        ],
      ),
    );
  }
}

class UKBottomAppBar extends StatelessWidget {
  const UKBottomAppBar({
    Key key,
    @required this.selectedPage,
    @required this.onPageSelected,
  }) : super(key: key);

  final Page selectedPage;
  final Function onPageSelected;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BottomAppBarItem(
            icon: Image.asset(
              'assets/icon/home.png',
              height: 20,
            ),
            isSelected: selectedPage == Page.Home,
            selectedIcon: Image.asset(
              'assets/icon/homeSelected.png',
              height: 20,
            ),
            name: "Home",
            selectedColor: getPrimaryColor(),
            callback: () {
              onPageSelected(Page.Home);
            },
          ),
          BottomAppBarItem(
            icon: Image.asset(
              'assets/icon/me.png',
              height: 20,
            ),
            isSelected: selectedPage == Page.Account,
            selectedIcon: Image.asset(
              'assets/icon/meSelected.png',
              height: 20,
            ),
            name: "Me",
            selectedColor: getPrimaryColor(),
            callback: () {
              onPageSelected(Page.Account);
            },
          ),
        ],
      ),
      color: Colors.white,
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/persistent_bottom_bar_scaffold.dart';
import 'package:vendeeimpressyon/export.dart';

class NavBar extends StatelessWidget {
  final String email;
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();

  NavBar({required this.email});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: HomePage(email: email),
          icon: Icons.home,
          title: '',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const Profil(),
          icon: Icons.person,
          title: '',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const Settings(),
          icon: Icons.settings,
          title: '',
          navigatorkey: _tab3navigatorKey,
        ),
      ],
    );
  }
}

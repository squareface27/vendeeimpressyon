import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/persistent_bottom_bar_scaffold.dart';
import 'package:vendeeimpressyon/export.dart';

class NavBar extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: HomePage(),
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
          tab: Settings(),
          icon: Icons.settings,
          title: '',
          navigatorkey: _tab3navigatorKey,
        ),
      ],
    );
  }
}

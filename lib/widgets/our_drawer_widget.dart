import 'package:duda_shelter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon,
  });
}

class DrawerItems {
  static const adopt = DrawerItem(title: "Adopt", icon: FontAwesomeIcons.paw);
  static const donate =
      DrawerItem(title: "Donate", icon: FontAwesomeIcons.handHoldingDollar);

  static const adminView =
      DrawerItem(title: "All", icon: FontAwesomeIcons.list);
  static const adminAdd = DrawerItem(title: "Add", icon: FontAwesomeIcons.plus);

  static const signout = DrawerItem(
      title: "Log out", icon: FontAwesomeIcons.arrowRightFromBracket);

  static final List<DrawerItem> all = [adopt, donate, signout];
  static final List<DrawerItem> adminAll = [adminView, adminAdd, signout];
}

class OurDrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const OurDrawerMenuWidget({
    super.key,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: const Icon(
        FontAwesomeIcons.alignLeft,
        color: Colors.black,
      ),
    );
  }
}

class OurDrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  final DrawerItem selectedDrawer;
  final bool isDrawerOpen;
  final bool isAdmin;

  const OurDrawerWidget({
    super.key,
    required this.onSelectedItem,
    required this.selectedDrawer,
    required this.isDrawerOpen,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          buildDrawerItems(context),
        ],
      );

  Widget buildDrawerItems(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: isAdmin
              ? DrawerItems.adminAll
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        leading: Icon(
                          size: isDrawerOpen ? 24 : 0,
                          item.icon,
                          color: item == selectedDrawer
                              ? selectedDrawerTextColor
                              : drawerTextColor,
                        ),
                        title: Text(
                          item.title,
                          softWrap: false,
                          style: TextStyle(
                            color: item == selectedDrawer
                                ? selectedDrawerTextColor
                                : drawerTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => onSelectedItem(item),
                      ))
                  .toList()
              : DrawerItems.all
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        leading: Icon(
                          size: isDrawerOpen ? 24 : 0,
                          item.icon,
                          color: item == selectedDrawer
                              ? selectedDrawerTextColor
                              : drawerTextColor,
                        ),
                        title: Text(
                          item.title,
                          softWrap: false,
                          style: TextStyle(
                            color: item == selectedDrawer
                                ? selectedDrawerTextColor
                                : drawerTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => onSelectedItem(item),
                      ))
                  .toList(),
        ),
      );
}

// ignore_for_file: file_names

import 'package:duda_shelter/pages/Admin/adminAdd.dart';
import 'package:duda_shelter/pages/Admin/adminView.dart';
import 'package:duda_shelter/pages/Auth/authPage.dart';
import 'package:duda_shelter/utils/constants.dart';
import 'package:duda_shelter/widgets/our_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OurAdminMainPage extends StatefulWidget {
  const OurAdminMainPage({super.key});

  @override
  State<OurAdminMainPage> createState() => _OurAdminMainPageState();
}

class _OurAdminMainPageState extends State<OurAdminMainPage> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  DrawerItem item = DrawerItems.adminView;
  DrawerItem currentItem = DrawerItems.adminView;

  @override
  void initState() {
    super.initState();

    closeDrawer();
  }

  void openDrawer() => setState(() {
        xOffset = 40;
        yOffset = 75;
        scaleFactor = 80;
        isDrawerOpen = true;
      });

  void closeDrawer() => setState(() {
        xOffset = 100;
        yOffset = 100;
        scaleFactor = 100;
        isDrawerOpen = false;
      });

  Widget getDrawerPage() {
    switch (item) {
      case DrawerItems.adminAdd:
        return OurAdminAddPage(
          openDrawer: openDrawer,
        );

      case DrawerItems.adminView:
      default:
        return OurAdminViewPage(
          openDrawer: openDrawer,
        );
    }
  }

  Widget buildDrawer() {
    return SafeArea(
      child: SizedBox(
        width: (1 - xOffset / 100) * MediaQuery.of(context).size.width,
        child: OurDrawerWidget(
          onSelectedItem: (item) {
            switch (item) {
              case DrawerItems.signout:
                if (FirebaseAuth.instance.currentUser != null) {
                  FirebaseAuth.instance.signOut();
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: ((context) => const OurAuth(isLogin: true)),
                    ),
                  );
                }
                return;

              default:
                setState(() {
                  this.item = item;
                  currentItem = item;
                });
                closeDrawer();
            }
          },
          selectedDrawer: currentItem,
          isDrawerOpen: isDrawerOpen,
          isAdmin: true,
        ),
      ),
    );
  }

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: ((details) {
          if (!isDragging) return;

          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }

          isDragging = false;
        }),
        onTap: closeDrawer,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(
                (1 - xOffset / 100) * MediaQuery.of(context).size.width,
                (1 - yOffset / 100) * MediaQuery.of(context).size.width,
                0)
              ..scale(scaleFactor / 100),
            child: AbsorbPointer(
              absorbing: isDrawerOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                child: Container(
                  color: isDrawerOpen ? Colors.white12 : Colors.white,
                  child: getDrawerPage(),
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [startingColor, ourPrimaryColor]),
        ),
        child: SafeArea(
          child: Stack(children: [
            buildDrawer(),
            buildPage(),
          ]),
        ),
      ),
    );
  }
}

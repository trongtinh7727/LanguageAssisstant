import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_icons.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view/account/account_screen.dart';
import 'package:languageassistant/view/discovery/discovery_screen.dart';
import 'package:languageassistant/view/home/home_screen.dart';
import 'package:languageassistant/view/library/library_screen.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  var currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check if currentUser is null and navigate to login screen if necessary
        if (_auth.currentUser == null) {
          Navigator.pushReplacementNamed(context, RouteName.loginScreen);
        } else {
          final homeViewModel =
              Provider.of<HomeViewModel>(context, listen: false);
          homeViewModel.fetchRecentTopics(_auth.currentUser!.uid, 10);
          homeViewModel.fetchNewTopics(5);
          homeViewModel.fetchTopTopics(10);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    if (displayWidth > 500) {
      displayWidth = 500;
    }
    final authProvider = Provider.of<AuthenticationProvider>(context);
    authProvider.setUserModel();

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          LibraryScreen(),
          DiscoveryScreen(),
          AccountScreen(
            userModel: authProvider.userModel,
          )
        ],
      ),
      bottomNavigationBar: Container(
        // margin: EdgeInsets.all(displayWidth * .05),
        height: displayWidth * .155,
        width: displayWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  if (_auth.currentUser != null) {
                    currentIndex = index;
                    final topicViewModel =
                        Provider.of<TopicViewModel>(context, listen: false);
                    final folderViewModel =
                        Provider.of<FolderViewModel>(context, listen: false);
                    final homeViewModel =
                        Provider.of<HomeViewModel>(context, listen: false);
                    switch (currentIndex) {
                      case 0:
                        homeViewModel.fetchRecentTopics(
                            _auth.currentUser!.uid, 10);
                        homeViewModel.fetchNewTopics(5);
                        homeViewModel.fetchTopTopics(10);
                        break;
                      case 1:
                        topicViewModel.fetchTopicsByUser(
                            _auth.currentUser!.uid, 5);
                        folderViewModel.fetchFoldersByUser(
                            _auth.currentUser!.uid, 5);
                        break;

                      default:
                    }
                  } else {
                    Navigator.pushReplacementNamed(
                        context, RouteName.loginScreen);
                  }
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex
                        ? displayWidth * .32
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? displayWidth * .12 : 0,
                      width: index == currentIndex ? displayWidth * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Colors.blueAccent.withOpacity(.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex
                        ? displayWidth * .31
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex
                                  ? displayWidth * .13
                                  : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == currentIndex ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == currentIndex
                                    ? '${listOfStrings[index]}'
                                    : '',
                                style: AppStyle.active,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex
                                  ? displayWidth * .03
                                  : 20,
                            ),
                            Icon(
                              index == currentIndex
                                  ? listOfFilledIcons[index]
                                  : listOfIcons[index],
                              size: displayWidth * .076,
                              color: index == currentIndex
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    LAIcons.home,
    LAIcons.book,
    Icons.explore_outlined,
    LAIcons.person,
  ];
  List<IconData> listOfFilledIcons = [
    LAIcons.home_fill,
    CupertinoIcons.book_solid,
    Icons.explore_sharp,
    LAIcons.person_fill,
  ];

  List<String> listOfStrings = [
    'Trang chủ',
    'Thư viện',
    'Khám phá',
    'Tài khoản',
  ];
}

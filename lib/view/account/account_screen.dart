import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  final UserModel? userModel;
  const AccountScreen({super.key, required this.userModel});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late HomeViewModel _homeViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final _homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Cá nhân'),
          actions: [
            IconButton(
              onPressed: () => {
                Navigator.pushNamed(context, RouteName.accountSettingScreen)
              },
              icon: Icon(Icons.more_vert_rounded),
            )
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: widget.userModel != null && _auth.currentUser != null
                    ? [
                        buildImage(widget.userModel!.avatarUrl!, () => {}),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: buildEditIcon(AppStyle.primaryColor,
                              widget.userModel!.id! == _auth.currentUser!.uid),
                        ),
                      ]
                    : [],
              ),
            ),
            Text('Bài viết', style: AppStyle.title),
            _newTopics(),
            if (_homeViewModel.isLoading)
              Text('Đang load', style: AppStyle.title),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imagePath, VoidCallback onClicked) {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color, bool isEdit) {
    return isEdit
        ? buildCircle(
            color: Colors.white,
            all: 3,
            child: buildCircle(
              color: color,
              all: 8,
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        : Column();
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget _newTopics() {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return SizedBox(
      height: 500, // Chiều cao cố định cho ListView.builder
      width: MediaQuery.of(context).size.width - 20,
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _homeViewModel.topics.length,
        itemBuilder: (context, index) {
          final topic = _homeViewModel.topics[index];
          return SizedBox(
            width: 320,
            height: 125,
            child: TopicCard(
              topic: topic,
              onContinue: () {
                // Handle continue action here
                _topicViewModel.fetchWordsByStatus(
                    _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                _topicViewModel.fetchLeaderBoard(topic.id);
                Navigator.pushNamed(context, RouteName.topicDetailScreen,
                    arguments: topic);
              },
            ),
          );
        },
      ),
    );
  }
}

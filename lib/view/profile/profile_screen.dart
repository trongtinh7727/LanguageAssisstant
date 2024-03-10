import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/profile_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _profileViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> showImagePickerOptions() async {
    if (_profileViewModel.userModel!.id! != _auth.currentUser!.uid) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          actions: <Widget>[
            TextButton(
              child: Text("Take Photo"),
              onPressed: () {
                Navigator.pop(context);
                takePhotoFromCamera();
              },
            ),
            TextButton(
              child: Text("Choose from Gallery"),
              onPressed: () {
                Navigator.pop(context);
                choosePhotoFromGallery();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> takePhotoFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _profileViewModel.uploadAvatar(_image!, _auth.currentUser!.uid);
      });
    }
  }

  Future<void> choosePhotoFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _profileViewModel.uploadAvatar(_image!, _auth.currentUser!.uid);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
  }

  bool _isScrollAtBottom(ScrollNotification notification) {
    return notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final _profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Cá nhân'),
          actions: [
            if (_profileViewModel.userModel?.id == _auth.currentUser!.uid)
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (_isScrollAtBottom(notification)) {
            if (!_profileViewModel.isLoading) {
              _profileViewModel.fetchPersonalTopicsMore(
                  authorID: _profileViewModel.userModel?.id ?? '', pageSize: 5);
            }
          }
          return false;
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: _profileViewModel.userModel != null &&
                                  _auth.currentUser != null
                              ? [
                                  buildImage(
                                      _profileViewModel.userModel!.avatarUrl!,
                                      showImagePickerOptions),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: showImagePickerOptions,
                                      child: buildEditIcon(
                                          AppStyle.primaryColor,
                                          _profileViewModel.userModel!.id! ==
                                              _auth.currentUser!.uid),
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                        Text(
                          _profileViewModel.userModel?.name ?? '',
                          style: AppStyle.title,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('Bài viết', style: AppStyle.title),
                    ],
                  ),
                  _newTopics(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String imagePath, VoidCallback onClicked) {
    final image = NetworkImage(imagePath);
    if (_image != null) {
      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: FileImage(_image!),
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(onTap: onClicked),
          ),
        ),
      );
    }
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
    final _profileViewModel = Provider.of<ProfileViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);

    return Column(
      children: [
        for (final topic in _profileViewModel.personalTopics)
          SizedBox(
            // width: 320,
            height: 130,
            child: TopicCard(
              topic: topic,
              onContinue: () {
                // Handle continue action here
                _topicViewModel.setTopic(topic);
                _topicViewModel.fetchTopic(_auth.currentUser!.uid, topic.id);

                _topicViewModel.fetchWordsByStatus(
                    _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                _topicViewModel.fetchLeaderBoard(topic.id);
                Navigator.pushNamed(
                  context,
                  RouteName.topicDetailScreen,
                );
              },
            ),
          ),
        if (_profileViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}

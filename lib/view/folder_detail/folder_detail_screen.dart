import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/bottomsheet_widget.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:languageassistant/widget/topic_leaderboard_item.dart';
import 'package:provider/provider.dart';

class FolderDetailScreen extends StatefulWidget {
  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  late FolderViewModel _folderViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _floderTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _folderViewModel = Provider.of<FolderViewModel>(context, listen: false);
  }

  void showUpdateFolderDialog() {
    _floderTextEditingController.text = _folderViewModel.folder!.title;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: const Text('Nhập tên folder')),
        content: TextFieldWidget(
            textEditingController: _floderTextEditingController),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Hủy'),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              _folderViewModel.folder!.updateTime =
                  DateTimeUtil.getCurrentTimestamp();
              _folderViewModel.folder!.title =
                  _floderTextEditingController.text;

              await _folderViewModel.updateFolder(
                  _auth.currentUser!.uid, _folderViewModel.folder!);
              _floderTextEditingController.text = '';

              _folderViewModel.setFolder(_folderViewModel.folder!);
              // _folderViewModel.fetchUserTopicsByFolder(
              //     _auth.currentUser!.uid, folderModel, 200);
              Navigator.pop(context, 'Xác nhận');
              Navigator.pop(context);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  bool _isScrollAtBottom(ScrollNotification notification) {
    return notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  void _showModalBottomSheet(BuildContext context) {
    BottomSheetItem _editTopic = BottomSheetItem(
      icon: Icon(Icons.edit_note_rounded, color: Colors.black),
      onTap: () {
        showUpdateFolderDialog();
      },
      text: "Chỉnh sửa",
    );
    BottomSheetItem _deleteTopic = BottomSheetItem(
      icon: Icon(Icons.delete_outline_rounded, color: Colors.black),
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Xóa folder này?'),
            content: const Text('Sau khi xóa sẽ không thể khôi phục được'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Hủy'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _folderViewModel.deleteFolder(
                      _auth.currentUser!.uid, _folderViewModel.folder!.id!);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      text: "Xóa",
    );
    BottomSheetItem _addToFolder = BottomSheetItem(
      icon: Icon(Icons.add_to_photos_outlined, color: Colors.black),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, RouteName.addTopicToFolder);
        // Navigator.pop(context);
      },
      text: "Thêm topics",
    );

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return BottomSheetWidget(
          menuItemCount: 2,
          bottomSheetItems: Column(children: [
            _editTopic,
            _deleteTopic,
            _addToFolder,
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _folderViewModel = Provider.of<FolderViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('IIEX'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert_rounded),
              onPressed: () {
                _showModalBottomSheet(context);
              },
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // if (_isScrollAtBottom(notification)) {
            //   if (!_folderViewModel.isLoading) {
            //     _folderViewModel.fetchNewTopicMore(5);
            //   }
            // }
            return false;
          },
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_folderViewModel.folder!.title,
                        style: const TextStyle(
                          color: AppStyle.activeText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.18,
                        )),
                    Text('${_folderViewModel.folder!.topicCount} topics',
                        style: const TextStyle(
                          color: AppStyle.activeText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.18,
                        )),
                    if (!_folderViewModel.isLoading)
                      _listTopics()
                    else
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _listTopics() {
    final _folderViewModel = Provider.of<FolderViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);

    return Column(
      children: [
        for (final topic in _folderViewModel.topics)
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
        if (_folderViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}

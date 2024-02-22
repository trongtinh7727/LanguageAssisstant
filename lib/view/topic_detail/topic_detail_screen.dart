import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_icons.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/view/topic_detail/components/topic_information.dart';
import 'package:languageassistant/view/topic_detail/components/topics_words.dart';
import 'package:languageassistant/view/topic_detail/components/toppic_leader_board.dart';
import 'package:languageassistant/view_model/add_topic_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/bottomsheet_widget.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:languageassistant/widget/user_leaderboard_item.dart';
import 'package:languageassistant/widget/word_item.dart';
import 'package:provider/provider.dart';

class TopicDetailScreen extends StatefulWidget {
  final TopicModel topic;
  const TopicDetailScreen({super.key, required this.topic});
  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late PageController pageController;
  late ScrollController _scrollController;
  late TopicViewModel topicViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int current = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    pageController = PageController();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Call load more method from your viewmodel
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int viewCount = widget.topic.viewCount;
    final int wordLearned = widget.topic.wordLearned;
    final int wordCount = widget.topic.wordCount;
    String wordProgress = "$wordCount";
    topicViewModel = Provider.of<TopicViewModel>(context, listen: true);

    if (widget.topic.wordLearned >= 0) {
      wordProgress = "$wordLearned/$wordCount";
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded),
            onPressed: () {
              // Handle add button
              _showModalBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    TopicInformation(
                        widget: widget,
                        viewCount: viewCount,
                        wordProgress: wordProgress),
                    SizedBox(
                      height: 8,
                    ),
                    TopicsLeaderBoard(topicViewModel: topicViewModel),
                    TopicsWords(
                        topicViewModel: topicViewModel,
                        userID: _auth.currentUser!.uid,
                        topicID: widget.topic.id),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void _showModalBottomSheet(BuildContext context) {
    BottomSheetItem _editTopic = BottomSheetItem(
      icon: Icon(Icons.edit_note_rounded, color: Colors.black),
      onTap: () {
        final _addTopicViewModel =
            Provider.of<AddTopicViewModel>(context, listen: false);
        _addTopicViewModel.setWords(topicViewModel.words);
        Navigator.pop(context);
        Navigator.pushNamed(context, RouteName.updateTopicScreen,
            arguments: widget.topic);
      },
      text: "Chỉnh sửa",
    );
    BottomSheetItem _deleteTopic = BottomSheetItem(
      icon: Icon(Icons.delete_outline_rounded, color: Colors.black),
      onTap: () {
        Navigator.pop(context);
        topicViewModel.delete(widget.topic.id);
        Navigator.pop(context);
      },
      text: "Xóa",
    );
    BottomSheetItem _addToFolder = BottomSheetItem(
      icon: Icon(Icons.add_to_photos_outlined, color: Colors.black),
      onTap: () {
        Navigator.pop(context);
      },
      text: "Thêm vào folder",
    );
    BottomSheetItem _exportCSV = BottomSheetItem(
      icon: Icon(LAIcons.import, color: Colors.black),
      onTap: () {
        Navigator.pop(context);
      },
      text: "Xuất ra file CSV",
    );
    BottomSheetItem _public = BottomSheetItem(
      icon: Icon(Icons.public, color: Colors.black),
      onTap: () {
        setState(() {
          widget.topic.public = !widget.topic.public;
          topicViewModel.setPublic(widget.topic.id, widget.topic.public);
          Navigator.pop(context);
          _showModalBottomSheet(context);
        });
      },
      isLoading: topicViewModel.isLoading,
      child: Row(
        children: [
          Text(
            'Trạng thái: ',
            style: AppStyle.title,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.topic.public ? 'Công khai' : 'Riêng tư',
            style: TextStyle(
                color: widget.topic.public
                    ? AppStyle.successColor
                    : AppStyle.redColor),
          ),
        ],
      ),
    );

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return BottomSheetWidget(
          menuItemCount: 3,
          bottomSheetItems: Column(children: [
            _editTopic,
            _deleteTopic,
            _addToFolder,
            _exportCSV,
            _public
          ]),
        );
      },
    );
  }
  // topicInforSection
}

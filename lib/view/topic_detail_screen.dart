import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
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

    const List<String> list = <String>[
      'Tất cả',
      'Đã học',
      'Chưa học',
      'Đã thành thạo'
    ];

    String dropdownValue = list.first;
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
                    topicInforSection(viewCount, wordProgress),
                    SizedBox(
                      height: 8,
                    ),
                    leaderBoardSection(),
                    wordSection(list, dropdownValue),
                  ],
                ),
              ),
            ),
          ),
          if (topicViewModel.isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Column wordSection(List<String> list, String dropdownValue) {
    return Column(
      children: [
        Row(
          children: [
            Text('Các thuật ngữ trong chủ đề',
                style: AppStyle.textTheme.headline6),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: DropdownMenu<String>(
                  initialSelection: list.first,
                  width: 150,
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    constraints: const BoxConstraints(maxHeight: 40),
                  ),
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                      switch (value) {
                        case "Tất cả":
                          topicViewModel.fetchWordsByStatus(
                            _auth.currentUser!.uid,
                            widget.topic.id,
                            WordStatus.ALL,
                          );
                          break;
                        case "Đã học":
                          topicViewModel.fetchWordsByStatus(
                            _auth.currentUser!.uid,
                            widget.topic.id,
                            WordStatus.LEARNED,
                          );
                          break;
                        case "Chưa học":
                          topicViewModel.fetchWordsByStatus(
                            _auth.currentUser!.uid,
                            widget.topic.id,
                            WordStatus.NOT_LEARNED,
                          );
                          break;
                        case "Đã thành thạo":
                          topicViewModel.fetchWordsByStatus(
                            _auth.currentUser!.uid,
                            widget.topic.id,
                            WordStatus.MASTERED,
                          );
                          break;
                      }
                    });
                  },
                  dropdownMenuEntries: list
                      .map<DropdownMenuEntry<String>>(
                        (String value) => DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                        ),
                      )
                      .toList(),
                  textStyle: AppStyle.body2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: topicViewModel.words.length,
          itemBuilder: (context, index) {
            final word = topicViewModel.words[index];
            final userID = _auth.currentUser!.uid;
            final topicID = widget.topic.id;

            return WordItem(
              word: word,
              topicID: topicID,
              userID: userID,
              topicViewModel: topicViewModel,
              backgroundColor:
                  index % 2 == 0 ? greyColor_100 : tabUnselectedColor,
            );
          },
        ),
      ],
    );
  }

  Column leaderBoardSection() {
    return Column(
      children: [
        Text(
          'Bảng Xếp Hạng',
          style: AppStyle.title,
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 200, // Adjust height accordingly
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topicViewModel
                .ranks.length, // Replace with the actual number of items
            itemBuilder: (context, index) {
              final item = topicViewModel.ranks[index];
              return UserLeaderBoardItem(
                userRank: item,
              );
            },
          ),
        ),
      ],
    );
  }

  // topicInforSection
  Container topicInforSection(int viewCount, String wordProgress) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.topic.title,
            maxLines: 5,
            style: AppStyle.headline,
          ),
          Row(
            children: [
              Text(
                '${DateTimeUtil.format(widget.topic.createTime)}',
                style: AppStyle.caption,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.remove_red_eye_outlined,
                color: primaryColor,
                size: 16,
              ),
              Text(
                '$viewCount',
                style: AppStyle.caption,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '$wordProgress words',
            style: AppStyle.caption,
          ),
          SizedBox(
            height: 8,
          ),
          if (widget.topic.wordLearned >= 0)
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: widget.topic.wordLearned / widget.topic.wordCount,
                  minHeight: 7,
                  backgroundColor: Colors.blue[100],
                  color: Colors.blue,
                ),
              ),
            ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.topic.authoravatar ??
                    'https://firebasestorage.googleapis.com/v0/b/language-assistant-7727.appspot.com/o/Users%2FAvatars%2Favatar_default.png?alt=media&token=490b3731-c6a2-4d1b-a75a-4902372c307b'),
                onBackgroundImageError: (exception, stackTrace) {
                  // Log the error, show a dialog, or use a fallback image
                  print('Error loading background image: $exception');
                },
                child: widget.topic.authoravatar == null
                    ? Icon(
                        Icons.person) // Fallback icon in case the URL is null
                    : null,
              ),
              SizedBox(width: 8),
              Text(
                widget.topic.authorName ?? "",
                style: AppStyle.caption,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Căn giữa và đều các nút

            children: [
              CustomButton(
                onContinue: () {},
                word: "Flashcard",
                btnBackground: Colors.white,
              ),
              CustomButton(
                onContinue: () {},
                word: "Điền từ",
                btnBackground: Colors.white,
              ),
              CustomButton(
                onContinue: () {},
                word: "Trắc nghiệm",
                btnBackground: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

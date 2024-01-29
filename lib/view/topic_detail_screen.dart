import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
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

  int current = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    pageController = PageController();
    topicViewModel = Provider.of<TopicViewModel>(context, listen: false);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     final topicViewModel =
    //         Provider.of<TopicViewModel>(context, listen: false);
    //     topicViewModel.fetchTopicsByUser('jQBsoZuLugWdlbCPWEDLShzw6tU2', 5);
    //   }
    // });
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
    final topicViewModel = Provider.of<TopicViewModel>(context);
    final int viewCount = widget.topic.viewCount;
    final int wordLearned = widget.topic.wordLearned;
    final int wordCount = widget.topic.wordCount;
    String wordProgress = "$wordCount";
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
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              topicInforSection(viewCount, wordProgress),
              Row(
                children: [
                  Text(
                    'Các thuật ngữ trong chủ đề',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DropdownMenu<String>(
                        initialSelection: list.first,
                        width: 150,
                        inputDecorationTheme: InputDecorationTheme(
                            isDense: true,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            constraints: const BoxConstraints(maxHeight: 40)),
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries:
                            list.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        }).toList(),
                        textStyle: TextStyle(
                          fontSize:
                              14, // Điều chỉnh kích thước font cho Dropdown
                          fontWeight: FontWeight
                              .normal, // Điều chỉnh độ đậm của font cho Dropdown
                          color: Colors
                              .black, // Điều chỉnh màu sắc của font cho Dropdown
                          // Căn lề phải cho Dropdown
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: topicViewModel.topics.length,
                  itemBuilder: (context, index) {
                    final word = new WordModel(createTime: 0, updateTime: 0);
                    return WordItem(
                      word: word,
                    );
                  },
                ),
              ),
            ],
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                '${DateTimeUtil.format(widget.topic.createTime)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
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
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '$wordProgress words',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
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
                style: TextStyle(
                  fontSize: 12,
                ),
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

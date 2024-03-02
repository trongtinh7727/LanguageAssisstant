import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/word_item.dart';

class TopicsWords extends StatelessWidget {
  const TopicsWords({
    super.key,
    required this.topicViewModel,
    required this.userID,
    required this.topicID,
  });

  final TopicViewModel topicViewModel;
  final String userID;
  final String topicID;

  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>[
      'Tất cả',
      'Đã học',
      'Chưa học',
      'Đã thành thạo'
    ];

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
                    topicViewModel.fillter(value!, userID, topicID);
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

            return WordItem(
              word: word,
              topicID: topicID,
              userID: userID,
              topicViewModel: topicViewModel,
              backgroundColor: Colors.white,
            );
          },
        ),
      ],
    );
  }
}

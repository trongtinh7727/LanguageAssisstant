import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/user_leaderboard_item.dart';

class TopicsLeaderBoard extends StatelessWidget {
  const TopicsLeaderBoard({
    super.key,
    required this.topicViewModel,
  });

  final TopicViewModel topicViewModel;

  @override
  Widget build(BuildContext context) {
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
          child: topicViewModel.ranks.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topicViewModel.ranks.length,
                  itemBuilder: (context, index) {
                    final item = topicViewModel.ranks[index];
                    return UserLeaderBoardItem(
                      userRank: item,
                    );
                  },
                )
              : Center(
                  child: Text("Chưa có dữ liệu"),
                ),
        ),
      ],
    );
  }
}
